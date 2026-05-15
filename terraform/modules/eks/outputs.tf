# terraform/modules/eks/outputs.tf

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate data for cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider (used for IRSA)"
  value       = aws_iam_openid_connect_provider.cluster.arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider (used for IRSA)"
  value       = aws_iam_openid_connect_provider.cluster.url
}