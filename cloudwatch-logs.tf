resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/${local.project_name}"
}
