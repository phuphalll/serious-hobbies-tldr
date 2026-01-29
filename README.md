# 🚀 Daily TLDR Automation (n8n + Docker)

This repository hosts the automation for generating a daily intelligence briefing covering Geopolitics, Markets, Tech, Health, Environment, and Thailand.

It runs as a **Serverless Batch Job** on Google Cloud Run, triggered daily by Cloud Scheduler.

## 🧠 Intelligence Terminal Philosophy
The core of this project is the **6-Pillar Intelligence Framework**. We don't just summarize news; we synthesize **Strategic Intelligence**.

### The 6 Pillars
1. **🌍 Geopolitics**: Great power competition, pivot points, quiet legislative moves.
2. **📈 Financial Markets**: Liquidity flows, cross-asset implications, AI credit cycles.
3. **⚡ Technology**: Agentic AI shifts, Google ecosystem updates, architectural breakthroughs.
4. **🧬 Health & Biotech**: Molecular mechanisms, longevity research, clinical translation.
5. **🌿 Environment**: Planetary signals, conservation tech, mitigation paradoxes.
6. **🇹🇭 Thailand Regional**: Counter-intuitive market insights, ASEAN context.

### Analytical Pipeline
Each pillar undergoes a rigorous two-pass process:
1. **Research Phase**: High-recall gathering of raw data (Strictly last 24h).
2. **Analysis Phase**: High-precision synthesis of strategic implications (Deep Knowledge extraction).
3. **Synthesis**: Merging all pillars into a cohesive narrative with cross-domain connections.
4. **Rendering**: Generating a premium "Obsidian" HTML report.

## 🏗 Architecture

- **Engine**: n8n (Headless/CLI mode)
- **Compute**: Google Cloud Run Jobs (Ephemeral containers)
- **Base Image**: Custom Alpine 3.22 + Python 3 + APK (`dockerfile.base`)
- **Scheduler**: Google Cloud Scheduler (Cron: `0 6 * * *` Asia/Bangkok)
- **Storage**: Supabase Storage (HTML Artifacts)
- **Secrets**: Cloud Run Environment Variables & Secret Manager

### Container Strategy
We use a **multi-stage image approach** to overcome the limitations of the default "distroless" n8n image:

1.  **Base Image (`dockerfile.base`)**: Extends `n8nio/n8n:2.6.1` by re-injecting Alpine's `apk` package manager and installing Python 3. This is pushed to Artifact Registry first.
2.  **App Image (`Dockerfile`)**: Builds FROM the custom base image, copying in:
    - `./workflows`: The JSON workflow definitions.
    - `./script`: The entrypoint logic (`docker-entrypoint.sh`).

## 🔄 Execution Logic (`docker-entrypoint.sh`)

The container supports three modes via the entrypoint:

1.  **`execute-server`** (Default): Starts standard n8n server (UI available).
2.  **`execute-daily`** (Batch):
    - Sets `TODAY_DATE`.
    - Imports credentials from `/opt/n8n/credentials`.
    - Starts n8n in background.
    - Waits for healthcheck.
    - Triggers `POST http://localhost:5678/webhook/batch`.
    - Captures result, shuts down n8n, and exits with 0 (success) or 1 (fail).
3.  **`execute-curl`** (Test): Similar to daily but triggers a test webhook.

## 🛠 Local Development & Testing

### 1. Setup
Copy the example environment file and fill in your keys (Supabase, Gemini, Encryption Key).
```bash
cp .env.example .env
```

### 2. Build App Image
```bash
docker build -t my-n8n-custom .
```

### 3. Run Locally (Batch Mode)
Simulate the Cloud Run Job:
```bash
docker run --rm \
    --name n8n_daily_job \
    --env-file .env \
    -v "$(pwd)/credentials":/opt/n8n/credentials \
    -v "$(pwd)/workflows":/opt/n8n/workflows \
    -v "$(pwd)/n8n-data":/home/node/.n8n \
    my-n8n-custom execute-daily
```

### 4. Run Locally (Test Mode)
Test the webhook connectivity:
```bash
docker run --rm \
    --name n8n_curl_test \
    --env-file .env \
    -v "$(pwd)/credentials":/opt/n8n/credentials \
    my-n8n-custom execute-curl
```

### 5. Run Locally (Editor Mode)
To edit workflows via the UI:
```bash
docker run -d \
    --name n8n_server \
    -p 5678:5678 \
    --env-file .env \
    -v "$(pwd)/credentials":/opt/n8n/credentials \
    -v "$(pwd)/workflows":/opt/n8n/workflows \
    -v "$(pwd)/n8n-data":/home/node/.n8n \
    my-n8n-custom execute-server
```
Access at `http://localhost:5678`.

## ☁️ Infrastructure as Code (Terraform)

This project uses Terraform to provision the entire Google Cloud infrastructure.

### Resources Provisioned
- **Artifact Registry**: `n8n-batch-repo` (Stores Base & App images)
- **Secret Manager**: `n8n-workflow-credentials` (Stores `secrets.json`)
- **Cloud Storage**: `[project-id]-n8n-config` (Stores `.env` file)
- **Cloud Run Job**: `n8n-daily-tldr` (The batch processor)
- **Cloud Scheduler**: Trigger `0 6 * * *` (Bangkok Time)
- **IAM**: Service Account permissions (`logWriter`, `objectViewer`, `run.invoker`)

### 1. Configuration
Navigate to the terraform directory and copy the variables file:
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```
Edit `terraform.tfvars` with your project details:
```hcl
project_id            = "your-project-id"
region                = "asia-southeast1"
service_account_email = "your-sa@project.iam.gserviceaccount.com"
```

### 2. Deployment
```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```

### 3. Post-Deployment Manual Steps
Terraform creates the resources, but you must populate the data:

1.  **Upload Credentials**:
    ```bash
    gcloud secrets versions add n8n-workflow-credentials --data-file=./credentials/secrets.json
    ```
2.  **Upload Environment Config**:
    ```bash
    gsutil cp .env gs://[YOUR-PROJECT-ID]-n8n-config/env_1
    ```

## ☁️ Production Deployment (CI/CD)

Once infrastructure is up, deploying updates involves building images and updating the Cloud Run Job.

### 1. Build & Push Base Image (Infrequent)
```bash
# Auth
gcloud auth configure-docker asia-southeast1-docker.pkg.dev

# Build & Push Base
docker build --platform=linux/amd64 -t asia-southeast1-docker.pkg.dev/serious-hobbies/n8n-python-base/base:v1 -f dockerfile.base .
docker push asia-southeast1-docker.pkg.dev/serious-hobbies/n8n-python-base/base:v1
```

### 2. Build & Push App Image
```bash
export PROJECT_ID=serious-hobbies
export IMAGE_TAG=asia-southeast1-docker.pkg.dev/$PROJECT_ID/n8n-tldr/app:latest

docker build --platform=linux/amd64 -t $IMAGE_TAG .
docker push $IMAGE_TAG
```

### 3. Update Cloud Run Job
```bash
gcloud run jobs update n8n-daily-tldr \
  --image asia-southeast1-docker.pkg.dev/$PROJECT_ID/n8n-tldr/app:latest \
  --region asia-southeast1
```

## 🔒 Security Notes
- **Credentials**: Never commit `credentials/*.json` or `.env`.
- **Secrets**: Use Cloud Secret Manager and mount them to `/opt/n8n/credentials` in production.
- **Access**: The n8n instance in Cloud Run runs in CLI mode (`execute-daily`) and does not expose HTTP ports.
