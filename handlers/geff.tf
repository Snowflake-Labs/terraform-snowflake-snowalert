module "geff_snowalert" {
  source  = "Snowflake-Labs/aws-geff/snowflake"
  version = "1.3.0"

  # General
  # prefix = var.prefix
  # env    = var.env

  # Snowflake
  # snowflake_integration_owner_role = var.terraform_role
  snowflake_account = var.snowflake_account

  # # AWS
  # aws_cloudwatch_metric_namespace = var.aws_cloudwatch_metric_namespace
  # aws_region                      = var.aws_region
  # deploy_lambda_in_vpc            = var.deploy_lambda_in_vpc
  # lambda_security_group_ids       = var.lambda_security_group_ids
  # lambda_subnet_ids               = var.lambda_subnet_ids

  # geff_image_version               = var.geff_image_version
  # data_bucket_arns                 = var.data_bucket_arns
  # snowflake_integration_user_roles = var.snowflake_integration_user_roles
}


