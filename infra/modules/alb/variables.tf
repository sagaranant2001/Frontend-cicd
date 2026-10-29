variable "project_name" {
  description = "Prefix used for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC for the target group"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnets for the load balancer"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for the load balancer"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path used for health checks"
  type        = string
  default     = "/health"
}