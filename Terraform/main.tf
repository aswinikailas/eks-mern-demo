terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
    profile = "machinetest"
    region = "eu-central-1" # Update to your region
} 
module "VPC" {
    source = "./modules/vpc"
    vpc_cidr = var.cidr_block
    cluster_name = var.cluster_name
    private_subnet_cidrs = var.private_subnet_cidrs
    availability_zones = var.availability_zones
    public_subnet_cidrs = var.public_subnet_cidrs
}
module "EKS" {
    source = "./modules/eks"
    cluster_name = var.cluster_name
    subnet_ids = module.VPC.private_subnet_ids
    cluster_version = var.cluster_version
    node_groups = var.node_groups

    # Update to your desired EKS version

}
module "ECR_frontend" {
    source = "./modules/ecr"
    ecr_repository_name = var.frontend_repository_name
}
module "ECR_backend" {
    source = "./modules/ecr"
    ecr_repository_name = var.backend_repository_name
}
