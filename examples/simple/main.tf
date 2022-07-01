module "snowalert" {
  source = "../../"

  # Optional
  env                = var.env
  prefix             = var.prefix
  geff_image_version = var.geff_image_version

  snowalert_user_email = var.snowalert_user_email
  create_tables        = var.create_tables
  handlers             = var.handlers

  providers = {
    snowflake.security_api_integration_role     = snowflake.security_api_integration_role
    snowflake.security_storage_integration_role = snowflake.security_storage_integration_role
    snowflake.security_admin_role               = snowflake.security_admin_role
    snowflake.security_alerting_role            = snowflake.security_alerting_role
    aws                                         = aws
  }
}
