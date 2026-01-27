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
- **Compute**: Google Cloud Run (Ephemeral containers)
- **Scheduler**: Google Cloud Scheduler (Cron: `0 8 * * *` Asia/Bangkok)
- **Storage**: Supabase Storage (HTML Artifacts)
- **Secrets**: Cloud Run Environment Variables
- **Prompts**: Managed via `PROMPTS.md` (Single Source of Truth)

## 🛠 Local Development & Testing

### 1. Setup
Copy the example environment file and fill in your keys (Supabase, Gemini, Encryption Key).
```bash
cp .env.example .env
```

### 2. Run Locally (Batch Mode)
Simulate the exact production batch job behavior:
```bash
docker compose run --rm n8n-batch
```
This will:
1. Start the container.
2. Import workflows and credentials from local folders.
3. Execute the "Daily Vibe" workflow.
4. Exit.

### 3. Run Locally (Editor Mode)
To edit workflows via the UI:
```bash
docker compose up -d n8n
```
Access at `http://localhost:5678`.

## ☁️ Production Deployment (Google Cloud)

### 1. Build & Push Image
```bash
export PROJECT_ID=your-project-id
docker build -t gcr.io/$PROJECT_ID/n8n-tldr:latest .
docker push gcr.io/$PROJECT_ID/n8n-tldr:latest
```

### 2. Secrets Management (Critical)
Since credentials are no longer baked into the image, you must mount them in Cloud Run.

1. **Package Credentials**:
   ```bash
   # Create a secret containing your credential files
   # (Alternatively, upload individual files if preferred)
   gcloud secrets create n8n-credentials --replication-policy="automatic"
   gcloud secrets versions add n8n-credentials --data-file=./credentials/secrets.json
   ```

2. **Deploy to Cloud Run Job**:
   Deploy as a Job with the credentials mounted to `/opt/n8n/credentials`.

   ```bash
   gcloud run jobs create n8n-daily-tldr \
     --image gcr.io/$PROJECT_ID/n8n-tldr:latest \
     --region asia-southeast1 \
     --set-env-vars N8N_ENCRYPTION_KEY=...,GEMINI_API_KEY=...,SUPABASE_URL=...,SUPABASE_KEY=...,SUPABASE_BUCKET_NAME=daily-tldr-reports \
     --set-secrets /opt/n8n/credentials/secrets.json=n8n-credentials:latest \
     --command "execute-daily" \
     --max-retries 1 \
     --task-timeout 15m
   ```

### 3. Schedule
```bash
gcloud scheduler jobs create http n8n-daily-trigger \
  --schedule "0 8 * * *" \
  --time-zone "Asia/Bangkok" \
  --uri "https://asia-southeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/$PROJECT_ID/jobs/n8n-daily-tldr:run" \
  --http-method POST \
  --oauth-service-account-email your-sa-email@...
```

## 🔒 Security Notes
- **Credentials**: Never commit `credentials/*.json` or `.env`.
- **Secrets**: Use Cloud Secret Manager and mount them to `/opt/n8n/credentials` in production.
- **Access**: The n8n instance in Cloud Run runs in CLI mode (`execute-daily`) and does not expose HTTP ports.
