variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "scan_on_push" {
  description = "Scan images for vulnerabilities when pushed"
  type        = bool
  default     = false
}