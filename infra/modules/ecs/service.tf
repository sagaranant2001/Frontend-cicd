resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn != "" ? [1] : []

    content {
      target_group_arn = var.target_group_arn
      container_name   = "frontend"
      container_port   = var.container_port
    }
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}