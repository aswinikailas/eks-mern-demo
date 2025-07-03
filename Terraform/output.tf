output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.EKS.cluster_endpoint
  
}
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.EKS.cluster_name
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.VPC.vpc_id
  
}