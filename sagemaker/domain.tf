data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "sagemaker_role" {
  name = "ban-sagemaker-${lower(terraform.workspace)}-role-alpha"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_policy_doc.json
  tags = var.tags
}

data "aws_iam_policy_document" "sagemaker_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

# Adjuntar políticas necesarias al rol
resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy" "sagemaker_studio_access" {
  name = "sagemaker-studio-access-alpha"
  role = aws_iam_role.sagemaker_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreatePresignedDomainUrl",
          "sagemaker:DescribeDomain",
          "sagemaker:ListDomains",
          "sagemaker:DescribeUserProfile",
          "sagemaker:ListUserProfiles",
          "sagemaker:*App",
          "sagemaker:ListApps",
          "iam:GetRole",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_domain" "domain" {
  domain_name = "ban-sagemaker-${lower(terraform.workspace)}-domain"
  auth_mode   = "SSO"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnets

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn

    canvas_app_settings {
      time_series_forecasting_settings {
        status = "ENABLED"
      }
    }
    jupyter_server_app_settings {
      default_resource_spec {
        instance_type = "system"
      }
    }
    studio_web_portal = "ENABLED"
  }

  default_space_settings {
    execution_role = aws_iam_role.sagemaker_role.arn

    kernel_gateway_app_settings {
      default_resource_spec {
        instance_type = "ml.t3.medium"
        sagemaker_image_arn = "arn:aws:sagemaker:${data.aws_region.current.name}:081325390199:image/sagemaker-data-science-310-v1"
      }
    }
  }

  tags = var.tags
  
}

resource "aws_sagemaker_user_profile" "profile" {
  for_each = var.sagemaker_definition
  domain_id         = aws_sagemaker_domain.domain.id
  user_profile_name = "ban-profile-${each.value.user_profile}"
  single_sign_on_user_identifier = "UserName"
  single_sign_on_user_value = each.value.mail
  depends_on = [ aws_sagemaker_domain.domain ]
  user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn

    canvas_app_settings {
      time_series_forecasting_settings {
        status = "ENABLED"
      }
    }

    jupyter_server_app_settings {
      default_resource_spec {
        instance_type = "system"
      }
    }

    studio_web_portal = "ENABLED"
  }
  tags = merge(var.tags, {
    UserProfile = each.value.user_profile
  })
}

#No aplica ya que se hace a través del SageMaker Studio
resource "aws_sagemaker_notebook_instance" "ni" {
  count = 0
  name          = "ban-notebook-instance"
  role_arn      = aws_iam_role.sagemaker_role.arn
  instance_type = "ml.t2.medium"

  tags = merge(var.tags, {
    Name = "ban-notebook-instance"
  })
}