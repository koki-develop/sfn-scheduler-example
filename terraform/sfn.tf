resource "aws_sfn_state_machine" "main" {
  name     = "${local.prefix}-state"
  role_arn = aws_iam_role.sfn.arn

  definition = jsonencode({
    StartAt = "Hello"
    States = {
      Hello = {
        Type   = "Pass"
        Result = "Hello, World!"
        End    = true
      }
    }
  })
}

resource "aws_iam_role" "sfn" {
  name               = "${local.prefix}-sfn-role"
  assume_role_policy = data.aws_iam_policy_document.sfn_assume_role_policy.json
}

data "aws_iam_policy_document" "sfn_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}
