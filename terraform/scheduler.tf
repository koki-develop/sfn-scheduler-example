resource "aws_scheduler_schedule" "main" {
  name                = "${local.prefix}-schedule"
  schedule_expression = "rate(30 minutes)"

  target {
    arn      = aws_sfn_state_machine.main.arn
    role_arn = aws_iam_role.scheduler.arn

    input = jsonencode({
      hoge = "fuga"
    })
  }

  flexible_time_window {
    mode = "OFF"
  }
}

resource "aws_iam_role" "scheduler" {
  name               = "${local.prefix}-scheduler-role"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role_policy.json
}

data "aws_iam_policy_document" "scheduler_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "scheduler" {
  role   = aws_iam_role.scheduler.name
  name   = "scheduler-policy"
  policy = data.aws_iam_policy_document.scheduler_policy.json
}

data "aws_iam_policy_document" "scheduler_policy" {
  statement {
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = [aws_sfn_state_machine.main.arn]
  }
}
