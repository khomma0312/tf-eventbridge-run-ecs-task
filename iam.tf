data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECSタスク実行Role
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${local.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECSタスクRole用ポリシー
data "aws_iam_policy_document" "ecs_task" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_task" {
  name   = "${local.project_name}-ecs-task-policy"
  policy = data.aws_iam_policy_document.ecs_task.json
}

# ECSタスクRole
resource "aws_iam_role" "ecs_task" {
  name               = "${local.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_task.arn
}


data "aws_iam_policy_document" "ecs_run_task" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:RunTask"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_task_scheduler" {
  name   = "${local.project_name}-scheduler-policy"
  policy = data.aws_iam_policy_document.ecs_run_task.json
}

# EventBridge Scheduler Role
resource "aws_iam_role" "ecs_task_scheduler" {
  name = "${local.project_name}-scheduler-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : ["scheduler.amazonaws.com"]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_scheduler_policy_attachment" {
  role       = aws_iam_role.ecs_task_scheduler.name
  policy_arn = aws_iam_policy.ecs_task_scheduler.arn
}
