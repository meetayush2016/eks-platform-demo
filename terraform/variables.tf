# terraform/variables.tf

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "env" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "ayush-demo-cluster"
}