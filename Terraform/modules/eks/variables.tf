variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
variable "cluster_version" {
  description = "Version of Kubernetes you wish to use"
}
variable "subnet_ids" {
  description = "Provide the Subnet Details"
}
variable "node_groups" {
  description = "Node groups with instance types and scaling config"
  type = map(object({
    instance_types = list(string)
    scaling_configs = object({
      desired_size = number
      min_size     = number
      max_size     = number
    })
  }))
}