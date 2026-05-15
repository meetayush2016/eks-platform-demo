# terraform/modules/vpc/variables.tf

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "env" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}