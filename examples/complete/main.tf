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

  alert_merge_schedule     = var.alert_merge_schedule
  alert_dispatch_schedule  = var.alert_dispatch_schedule
  alert_scheduler_schedule = var.alert_scheduler_schedule

  create_warehouse     = var.create_warehouse
  create_database      = var.create_database
  create_user          = var.create_user
  snowalert_user_email = var.snowalert_user_email
  create_role          = var.create_role
  create_schemas       = var.create_schemas
  create_tables        = var.create_tables

  data_schema_name    = var.data_schema_name
  rules_schema_name   = var.rules_schema_name
  results_schema_name = var.results_schema_name

  security_integration_role = var.security_integration_role
  security_admin_role       = var.security_admin_role
  security_alerting_role    = var.security_alerting_role
  security_ingest_role      = var.security_ingest_role
  security_modeling_role    = var.security_modeling_role
  security_monitoring_role  = var.security_monitoring_role
  snowalert_app_role        = var.snowalert_app_role

  handlers          = var.handlers
  slack_secrets_arn = var.slack_secrets_arn

  jira_secrets_arn        = var.jira_secrets_arn
  jira_url                = var.jira_url
  default_jira_project    = var.default_jira_project
  default_jira_issue_type = var.default_jira_issue_type

  smtp_secrets_arn               = var.smtp_secrets_arn
  smtp_driver_from_email_address = var.smtp_driver_from_email_address

  servicenow_secrets_arn = var.servicenow_secrets_arn
  servicenow_api_url     = var.servicenow_api_url

  providers = {
    snowflake.security_api_integration_role     = snowflake.security_api_integration_role
    snowflake.security_storage_integration_role = snowflake.security_storage_integration_role
    snowflake.security_admin_role               = snowflake.security_admin_role
    snowflake.security_alerting_role            = snowflake.security_alerting_role
    aws                                         = aws
  }
}
