locals {
  # 毎月1日の4時に実行する
  ecs_run_task_schedule = "cron(0 4 1 * ? *)"
  aws_account_id        = data.aws_caller_identity.current.account_id
}

resource "aws_scheduler_schedule" "ecs_run_task_scheduler" {
  name       = "${local.project_name}-scheduler"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = local.ecs_run_task_schedule
  schedule_expression_timezone = "Asia/Tokyo"

  target {
    arn      = aws_ecs_cluster.main.arn
    role_arn = aws_iam_role.ecs_task_scheduler.arn

    ecs_parameters {
      task_definition_arn = "arn:aws:ecs:ap-northeast-1:${local.aws_account_id}:task-definition/${local.project_name}"
      launch_type         = "FARGATE"
      platform_version    = "LATEST"
      network_configuration {
        subnets         = [aws_subnet.private.id]
        security_groups = [aws_security_group.ecs.id]
      }
    }

    input = jsonencode({
      containerOverrides = [
        {
          name = local.project_name
          environment = [
            {
              name  = "JOB_NAME"
              value = "bar"
            }
          ]
        }
      ]
    })
  }
}
