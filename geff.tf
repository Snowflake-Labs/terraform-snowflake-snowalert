module "geff_snowalert" {
  source  = "Snowflake-Labs/aws-geff/snowflake"
  version = "1.3.0"

  # Required
  prefix = var.prefix
  env    = var.env

  # Snowflake
  snowflake_integration_owner_role = var.terraform_role
  snowflake_account                = var.snowflake_account
  snowflake_integration_user_roles = var.snowflake_integration_user_roles

  # AWS
  aws_region = "us-west-2"

  # Other config items
  geff_image_version = var.geff_image_version
  data_bucket_arns   = var.data_bucket_arns
}
