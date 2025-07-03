variable "cidr_block" {

  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "cluster_name" {

  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
  
}
variable "availability_zones" {

  description = "List of availability zones for the VPC"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

}
variable "private_subnet_cidrs" {

  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

}
variable "public_subnet_cidrs" {

  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.6.0/24"]

}
variable "cluster_version" {

  description = "The version of the EKS cluster"
  type        = string
  default     = "1.27" # Update to your desired EKS version 
  
}
variable "node_groups" {

  description = "Map of node groups with their configurations"
  type = map(object({
    instance_types = list(string)
    scaling_configs = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  default = {
    "ng1" = {
      instance_types = ["t3.medium"]
      scaling_configs = {
        desired_size = 2
        max_size     = 3
        min_size     = 1
      }
    }
    "ng2" = {
      instance_types = ["t3.medium"]
      scaling_configs = {
        desired_size = 2
        max_size     = 3
        min_size     = 1
      }
    }
  }
  
}
variable "frontend_repository_name" {

  description = "The name of the ECR repository"
  type        = string
  default     = "frontend" # Update to your desired ECR repository name
  
}
variable "backend_repository_name" {

  description = "The name of the ECR repository"
  type        = string
  default     = "backend" # Update to your desired ECR repository name
  
}