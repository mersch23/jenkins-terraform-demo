variable "environment" {
  type        = string
  description = "Target environment (dev, staging, prod)"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
