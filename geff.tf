module "geff_snowalert" {
  source = "Snowflake-Labs/aws-geff/snowflake"

  # Required
  prefix = var.prefix
  env    = var.env

  # Snowflake
  snowflake_integration_user_roles = var.snowflake_integration_user_roles

  # AWS
  aws_region = local.aws_region

  # Other config items
  geff_image_version = var.geff_image_version
  data_bucket_arns   = var.data_bucket_arns

  providers = {
    snowflake.api_integration     = snowflake.api_integration
    snowflake.storage_integration = snowflake.storage_integration
    aws                           = aws
  }
}
