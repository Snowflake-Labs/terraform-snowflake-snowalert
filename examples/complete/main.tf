module "snowalert" {
  source = "../../"

  # Optional
  env    = var.env
  prefix = var.prefix

  snowalert_warehouse_name = var.snowalert_warehouse_name
  snowalert_database_name  = var.snowalert_database_name
  snowalert_user_name      = var.snowalert_user_name
  snowalert_role_name      = var.snowalert_role_name

  handlers                       = var.handlers
  jira_secrets_arn               = var.jira_secrets_arn
  slack_secrets_arn              = var.slack_secrets_arn
  smtp_secrets_arn               = var.smtp_secrets_arn
  smtp_driver_from_email_address = var.smtp_driver_from_email_address
  geff_image_version             = var.geff_image_version

  providers = {
    snowflake.api_integration     = snowflake.api_integration
    snowflake.storage_integration = snowflake.storage_integration
    snowflake.admin               = snowflake.admin
    snowflake.alerting_role       = snowflake.alerting_role
    aws                           = aws
  }
}
