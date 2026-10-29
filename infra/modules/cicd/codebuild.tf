resource "aws_codebuild_project" "this" {
  name         = "${var.project_name}-build"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "ECR_REPO_URL"
      value = var.ecr_repository_url
    }

    environment_variable {
      name  = "ECS_CLUSTER"
      value = var.ecs_cluster_name
    }

    environment_variable {
      name  = "ECS_SERVICE"
      value = var.ecs_service_name
    }

    environment_variable {
      name  = "TASK_FAMILY"
      value = var.ecs_task_family
    }

    environment_variable {
      name  = "AWS_ENDPOINT_URL"
      value = var.aws_endpoint_url
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}
