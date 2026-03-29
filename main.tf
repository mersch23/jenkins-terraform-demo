terraform {
  required_version = ">= 1.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "demo" {
  bucket = "jenkins-tf-demo-${var.environment}-${random_id.suffix.hex}"

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Pipeline    = "jenkins"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
