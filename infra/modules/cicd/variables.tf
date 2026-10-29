variable "project_name" {
  description = "Prefix used for naming resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "ecs_task_family" {
  description = "ECS task definition family"
  type        = string
}

variable "source_object_key" {
  description = "Object key of the source zip in the source bucket"
  type        = string
  default     = "source.zip"
}

variable "aws_endpoint_url" {
  description = "Endpoint the build container uses to reach AWS APIs (empty for real AWS)"
  type        = string
  default     = ""
}