variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "floci_endpoint" {
  description = "Floci endpoint used by Terraform from your machine"
  type        = string
  default     = "http://localhost:4566"
}

variable "build_endpoint" {
  description = "Floci endpoint as seen from inside the CodeBuild container"
  type        = string
  default     = "http://host.docker.internal:4566"
}

variable "project_name" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "frontend"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "enable_alb" {
  description = "Create the ALB module and attach it to the ECS service"
  type        = bool
  default     = false
}

