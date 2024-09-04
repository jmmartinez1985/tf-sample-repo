locals {
  name = "sample-grafana"
  description =  "sample-grafana demo"
}


module "managed_grafana" {
  source  = "terraform-aws-modules/managed-service-grafana/aws"
  version = "2.1.1"

  # Workspace
  name                      = local.name
  associate_license         = false
  description               = local.description
  account_access_type       = "CURRENT_ACCOUNT"
  authentication_providers  = ["AWS_SSO"]
  permission_type           = "SERVICE_MANAGED"
  data_sources              = ["CLOUDWATCH", "PROMETHEUS", "XRAY", "AMAZON_OPENSEARCH_SERVICE"]
  notification_destinations = ["SNS"]
  stack_set_name            = local.name
  grafana_version           = "10.4"

  configuration = jsonencode({
    unifiedAlerting = {
      enabled = true
    },
    plugins = {
      pluginAdminEnabled = false
    }
  })

  # vpc configuration
  vpc_configuration = {
    subnet_ids =  data.terraform_remote_state.vpc.outputs.private_subnets
  }
  security_group_rules = {
    egress_opensearch= {
      description = "Allow egress to OpenSearch"
      from_port   = 9200
      to_port     = 9200
      protocol    = "tcp"
      cidr_blocks =  data.terraform_remote_state.vpc.outputs.private_subnets_cidr
    }
  }

  # Workspace API keys
  workspace_api_keys = {
    viewer = {
      key_name        = "viewer"
      key_role        = "VIEWER"
      seconds_to_live = 3600
    }
    editor = {
      key_name        = "editor"
      key_role        = "EDITOR"
      seconds_to_live = 3600
    }
    admin = {
      key_name        = "admin"
      key_role        = "ADMIN"
      seconds_to_live = 3600
    }
  }

  # Workspace service accounts
  

  # Workspace IAM role
  create_iam_role                = true
  iam_role_name                  = local.name
  use_iam_role_name_prefix       = true
  iam_role_description           = local.description
  iam_role_path                  = "/grafana/"
  iam_role_force_detach_policies = true
  iam_role_max_session_duration  = 7200
  iam_role_tags                  = { role = true }

  tags = var.tags
}