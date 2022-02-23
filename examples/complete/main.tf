module "snowalert" {
  source = "../../"

  # Optional
  env               = var.env
  prefix            = var.prefix
  terraform_role    = var.terraform_role
  snowflake_account = var.snowflake_account

  snowalert_db_name        = var.snowalert_db_name
  snowalert_role_name      = var.snowalert_role_name
  snowalert_warehouse_name = var.snowalert_warehouse_name

  handlers                       = var.handlers
  jira_secrets_arn               = var.jira_secrets_arn
  slack_secrets_arn              = var.slack_secrets_arn
  smtp_secrets_arn               = var.smtp_secrets_arn
  smtp_driver_from_email_address = var.smtp_driver_from_email_address
  geff_image_version             = var.geff_image_version

  providers = {
    snowflake.api_integration     = snowflake.api_integration
    snowflake.storage_integration = snowflake.storage_integration
    aws                           = aws
  }
}
