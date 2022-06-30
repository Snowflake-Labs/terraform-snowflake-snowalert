module "snowalert" {
  source = "../../"

  # Optional
  env                              = var.env
  prefix                           = var.prefix
  geff_image_version               = var.geff_image_version
  snowalert_warehouse_size         = var.snowalert_warehouse_size
  snowflake_integration_user_roles = [var.snowalert_role_name]

  snowalert_warehouse_name = var.snowalert_warehouse_name
  snowalert_database_name  = var.snowalert_database_name
  snowalert_user_name      = var.snowalert_user_name
  snowalert_role_name      = var.snowalert_role_name
  snowalert_user_email     = var.snowalert_user_email
  create_tables            = var.create_tables

  handlers          = var.handlers
  slack_secrets_arn = var.slack_secrets_arn

  providers = {
    snowflake.security_api_integration_role     = snowflake.security_api_integration_role
    snowflake.security_storage_integration_role = snowflake.security_storage_integration_role
    snowflake.security_admin_role               = snowflake.security_admin_role
    snowflake.security_alerting_role            = snowflake.security_alerting_role
    aws                                         = aws
  }
}
