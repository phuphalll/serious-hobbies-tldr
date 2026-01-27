variable "project_id" {
  description = "The Google Cloud Project ID where resources will be deployed."
  type        = string
  # sensitive   = true # Uncomment if you consider the Project ID sensitive output
}

variable "region" {
  description = "The Google Cloud region for the Cloud Run Job and Artifact Registry."
  type        = string
  default     = "asia-southeast1" # Aligned with your timezone (Bangkok)
}

variable "service_account_email" {
  description = "The existing Service Account email to run the Cloud Run Job."
  type        = string
  default     = "rseptest@gogowas.iam.gserviceaccount.com"
}

variable "service_account_id" {
  description = "The unique ID of the existing Service Account (for reference/validation)."
  type        = string
  default     = "5215151f0069834353"
}

variable "n8n_image_repository" {
  description = "The name of the Artifact Registry repository."
  type        = string
  default     = "n8n-batch-repo"
}

variable "job_name" {
  description = "The name of the Cloud Run Job."
  type        = string
  default     = "n8n-daily-tldr"
}