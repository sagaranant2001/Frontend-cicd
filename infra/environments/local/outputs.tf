output "vpc_id" {
  value = module.network.vpc_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "pipeline_name" {
  value = module.cicd.pipeline_name
}

output "codebuild_project_name" {
  value = module.cicd.codebuild_project_name
}

output "source_bucket_name" {
  value = module.cicd.source_bucket_name
}

output "alb_dns_name" {
  value = var.enable_alb ? module.alb[0].alb_dns_name : "ALB disabled"
}



