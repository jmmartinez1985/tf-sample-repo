
resource "random_string" "random" {
  length           = 10
  special          = false

}

# Datos de la cuenta actual de AWS
data "aws_caller_identity" "current" {}

# Recurso: Rol IAM
resource "aws_iam_role" "ssm_role" {
  name = "SSMSessionManagerRole-${random_string.random.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

}

# Recurso: Política IAM
resource "aws_iam_policy" "ssm_policy" {
  name        = "SSMSessionManagerPolicy-${random_string.random.result}"
  path        = "/"
  description = "Política para SSM Session Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession"
        ]
        Resource = [
          "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/${aws_instance.ec2.id}",
          "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:document/SSM-SessionManagerRunShell"
        ]
        Condition = {
          BoolIfExists = {
            "ssm:SessionDocumentAccessCheck" = "true"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:DescribeInstanceProperties",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ]
        Resource = [
          "arn:aws:ssm:*:*:session/$${aws:username}-*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]
        Resource = "*"
      }
    ]
  })
}

# Recurso: Adjuntar la política al rol
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}



