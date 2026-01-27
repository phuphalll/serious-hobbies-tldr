# ==========================================
# 1. CORE PROJECT CONFIGURATION
# ==========================================

variable "project_id" {
  description = "The Google Cloud Project ID where resources will be deployed. (Must be an existing project)"
  type        = string
  # No default value ensures you must explicitly provide it, preventing accidental deployments to wrong projects.
}

variable "region" {
  description = "The Google Cloud region for the Cloud Run Job, Artifact Registry, and Storage Bucket."
  type        = string
  default     = "asia-southeast1" # Bangkok region
}

# ==========================================
# 2. SECURITY & IDENTITY
# ==========================================

variable "service_account_email" {
  description = "The existing Service Account email that will run the Cloud Run Job and own the resources."
  type        = string
  default     = "rseptest@gogowas.iam.gserviceaccount.com"
  
  validation {
    condition     = can(regex(".*@.*\\.iam\\.gserviceaccount\\.com$", var.service_account_email))
    error_message = "The service_account_email must be a valid Google Service Account email address."
  }
}

# ==========================================
# 3. RESOURCE NAMING
# ==========================================

variable "n8n_image_repository" {
  description = "The name of the Artifact Registry repository to create/use."
  type        = string
  default     = "n8n-batch-repo"
}

variable "job_name" {
  description = "The name of the Cloud Run Job resource."
  type        = string
  default     = "n8n-daily-tldr"
}

# ==========================================
# 4. SCHEDULING CONFIGURATION
# ==========================================

variable "cron_schedule" {
  description = "The unix-cron format schedule for the job trigger."
  type        = string
  default     = "0 6 * * *" # Every day at 6:00 AM
}

variable "time_zone" {
  description = "The time zone for the Cloud Scheduler job."
  type        = string
  default     = "Asia/Bangkok"
}