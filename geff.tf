module "geff_snowalert" {
  count  = length(var.handlers) > 0 ? 1 : 0
  source = "Snowflake-Labs/api-integration-with-geff-aws/snowflake"
  version = "0.3.7"

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
  geff_secret_arns   = local.snowalert_secret_arns

  providers = {
    snowflake.api_integration_role     = snowflake.api_integration_role
    snowflake.storage_integration_role = snowflake.storage_integration_role
    snowsql.storage_integration_role   = snowsql.storage_integration_role
    aws                                = aws
  }
}
