variable "project_name" {
  description = "Prefix used for naming resources"
  type        = string
}

variable "container_image" {
  description = "Initial image URI for the container"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "Subnets for the service"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for the service"
  type        = string
}

variable "aws_region" {
  description = "Region used by the log driver"
  type        = string
  default     = "us-east-1"
}

variable "target_group_arn" {
  description = "Optional ALB target group ARN. Leave empty to run without a load balancer."
  type        = string
  default     = ""
}