provider "google" {
  project = var.project_id
  region  = var.region
}
# ---------------------------------------------------------
# 0. ENABLE GOOGLE CLOUD APIS
# ---------------------------------------------------------
resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",              # Cloud Run
    "cloudscheduler.googleapis.com",   # Cloud Scheduler (You will likely need this next)
    "artifactregistry.googleapis.com", # Artifact Registry
    "secretmanager.googleapis.com",    # Secret Manager
    "iam.googleapis.com"               # IAM
  ])

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false # IMPORTANT: Prevents accidental API disablement on destroy
}
# ---------------------------------------------------------
# 1. ARTIFACT REGISTRY (Store Docker Images)
# ---------------------------------------------------------
resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "n8n-batch-repo"
  description   = "Docker repository for n8n batch jobs"
  format        = "DOCKER"
}

# ---------------------------------------------------------
# 2. IAM & SECURITY (Least Privilege Service Account)
# ---------------------------------------------------------
data "google_service_account" "existing_n8n_sa" {
  account_id = var.service_account_email
}

# Grant permissions to pull images, read secrets, and write logs
resource "google_project_iam_member" "sa_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/artifactregistry.reader",
    "roles/secretmanager.secretAccessor",
    "roles/storage.objectViewer", # To read .env from GCS
    "roles/run.invoker" # Required for the Scheduler to invoke the job
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${data.google_service_account.existing_n8n_sa.email}"
}

# ---------------------------------------------------------
# 3. SECRET MANAGER (For n8n Credentials)
# ---------------------------------------------------------
# Create a secret for the exported n8n credentials JSON
resource "google_secret_manager_secret" "n8n_creds" {
  secret_id = "n8n-workflow-credentials"
  replication {
    auto {}
  }
}

# Note: You must manually upload the payload via Console or CLI:
# gcloud secrets versions add n8n-workflow-credentials --data-file=./credentials/secrets.json

# ---------------------------------------------------------
# 4. CLOUD STORAGE (For .env File)
# ---------------------------------------------------------
resource "google_storage_bucket" "env_bucket" {
  name          = "${var.project_id}-n8n-config"
  location      = var.region
  uniform_bucket_level_access = true
}

# ---------------------------------------------------------
# 5. CLOUD RUN JOB
# ---------------------------------------------------------
resource "google_cloud_run_v2_job" "n8n_job" {
  name     = var.job_name
  location = var.region
  template {
    template {
      service_account = var.service_account_email
      timeout     = "7200s"
      containers {
        # Image will be built by Cloud Build
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/n8n-custom:latest"
        
        name = "n8n-job"

        # Resources - Batch jobs might need more memory
        resources {
          limits = {
            cpu    = "2"
            memory = "4Gi"
          }
        }

        # --- VOLUME MOUNTS ---
        # 1. Mount Secret Manager secret as a file for n8n to import
        volume_mounts {
          name       = "n8n-creds-vol"
          mount_path = "/opt/n8n/credentials" # docker-entrypoint.sh looks here
        }

        # 2. Mount GCS Bucket to access .env
        volume_mounts {
          name       = "gcs-env-vol"
          mount_path = "/mnt/gcs"
        }

        # --- COMMAND OVERRIDE ---
        # We wrap the entrypoint to source the .env file from the GCS mount
        # "set -a" automatically exports all variables in the sourced file
        command = ["/bin/sh", "-c"]
        args    = [
          "if [ -f /mnt/gcs/env_1 ]; then echo 'Loading env_1 from GCS...'; set -a; . /mnt/gcs/env_1; set +a; fi;export TODAY_DATE=$(date +%Y-%m-%d);.echo \"📅 Job Date: $TODAY_DATE\";. /opt/n8n/docker-entrypoint.sh execute-daily"
        ]
        
        # Ensure standard n8n encryption key is present if not in .env
        # It's safer to have this critical key in Secret Manager mapped to Env Var directly
        # env {
        #   name = "N8N_ENCRYPTION_KEY"
        #   value_source {
        #     secret_key_ref {
        #       secret = "n8n-encryption-key" # Create this secret if needed
        #       version = "latest"
        #     }
        #   }
        # }
      }

      # --- VOLUMES DEFINITION ---
      volumes {
        name = "n8n-creds-vol"
        secret {
          secret = google_secret_manager_secret.n8n_creds.secret_id
          default_mode = 292 # 0444 in decimal
          items {
            version = "latest"
            path    = "secrets.json" # Files will appear at /opt/n8n/credentials/secrets.json
          }
        }
      }

      volumes {
        name = "gcs-env-vol"
        gcs {
          bucket = google_storage_bucket.env_bucket.name
          read_only = true
        }
      }
    }
  }
  
  lifecycle {
    ignore_changes = [
      client,
      client_version,
      template[0].template[0].containers[0].image # Allow Cloud Build to update image
    ]
  }
}

# ---------------------------------------------------------
# 6. CLOUD SCHEDULER (Trigger 6 AM Daily)
# ---------------------------------------------------------
resource "google_cloud_scheduler_job" "job_trigger" {
  name             = "trigger-n8n-daily"
  description      = "Triggers the n8n daily TLDR batch job"
  schedule         = var.cron_schedule
  time_zone        = var.time_zone
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.n8n_job.name}:run"

    oauth_token {
      service_account_email = var.service_account_email
    }
  }
}