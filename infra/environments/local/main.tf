module "network" {
  source = "../../modules/network"

  project_name   = var.project_name
  container_port = var.container_port
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "${var.project_name}-repo"
}

module "alb" {
  count  = var.enable_alb ? 1 : 0
  source = "../../modules/alb"

  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = module.network.security_group_id
  container_port    = var.container_port
}

module "ecs" {
  source = "../../modules/ecs"

  project_name      = var.project_name
  aws_region        = var.aws_region
  container_image   = "${module.ecr.repository_url}:latest"
  container_port    = var.container_port
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = module.network.security_group_id
  target_group_arn  = var.enable_alb ? module.alb[0].target_group_arn : ""
}

module "cicd" {
  source = "../../modules/cicd"

  project_name       = var.project_name
  aws_region         = var.aws_region
  ecr_repository_url = module.ecr.repository_url
  ecs_cluster_name   = module.ecs.cluster_name
  ecs_service_name   = module.ecs.service_name
  ecs_task_family    = module.ecs.task_family
  aws_endpoint_url   = var.build_endpoint
}
