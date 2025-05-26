# SSM Automation 
# IAM Role for SSM Automatio
resource "aws_iam_role" "ssm_automation_role" {
  name = "ssm-automation-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "pass_role_policy" {
  name        = "ssm-pass-role-policy"

  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_pass_role_policy_attachment" {
  role       = aws_iam_role.ssm_automation_role.name
  policy_arn = aws_iam_policy.pass_role_policy.arn
}


resource "aws_iam_role_policy_attachment" "ssm_automation_policy_attachment" {
  role       = aws_iam_role.ssm_automation_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}

resource "aws_ssm_document" "child_1" {
  name            = "child-1"
  document_type   = "Automation"
  document_format = "YAML"
  content = templatefile("templates/child-1.yaml", {
    automation_role = aws_iam_role.ssm_automation_role.arn
  })
}

resource "aws_ssm_document" "child_2" {
  name            = "child-2"
  document_type   = "Automation"
  document_format = "YAML"
  content = templatefile("templates/child-2.yaml", {
    automation_role = aws_iam_role.ssm_automation_role.arn
  })
}


resource "aws_ssm_document" "main" {
  name            = "main"
  document_type   = "Automation"
  document_format = "YAML"
  content = templatefile("templates/main.yaml", {
    automation_role = aws_iam_role.ssm_automation_role.arn
  })
}