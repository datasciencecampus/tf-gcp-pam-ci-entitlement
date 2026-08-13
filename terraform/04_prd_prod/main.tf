terraform {
  required_version = "~> 1.14.3"
  backend "gcs" {
    bucket = ""
    prefix = "terraform/04_prd_prod"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.41.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

locals {
  required_services = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage.googleapis.com",
    "serviceusage.googleapis.com"
  ])
}

resource "google_project_service" "required" {
  for_each = local.required_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}


module "terraform_ci_setup" {
  source = "github.com/datasciencecampus/tf-gcp-bootstrap?ref=187ee236956b63d38d21a80b4f6b7585fcec2999"

  depends_on = [
    google_project_service.required
  ]

  project_id                   = var.project_id
  host_service_account_email   = var.host_service_account_email
  target_service_account_email = var.target_service_account_email

  target_service_account_additional_roles = var.target_service_account_additional_roles
}
