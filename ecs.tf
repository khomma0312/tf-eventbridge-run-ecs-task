resource "aws_ecs_cluster" "main" {
  name = "${local.project_name}-cluster"
}

# 手動で先に作成しておいてもOK
resource "aws_ecr_repository" "main" {
  name = "${local.project_name}-repository"
}
