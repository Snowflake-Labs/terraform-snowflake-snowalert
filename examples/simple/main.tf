module "snowalert" {
  source = "../../"

  # Optional
  env                = var.env
  prefix             = var.prefix
  geff_image_version = var.geff_image_version

  snowalert_user_email = var.snowalert_user_email
  create_tables        = var.create_tables
  handlers             = var.handlers
  slack_secrets_arn    = var.slack_secrets_arn

  providers = {
    snowflake.api_integration_role     = snowflake.api_integration_role
    snowflake.storage_integration_role = snowflake.storage_integration_role
    snowflake.admin_role               = snowflake.admin_role
    snowflake.alerting_role            = snowflake.alerting_role
    aws                                = aws
  }
}
