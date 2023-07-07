module "snowalert" {
  source = "../../"

  # Optional
  env    = var.env
  prefix = var.prefix

  # GEFF
  aws_region         = var.aws_region
  arn_format         = var.arn_format
  geff_image_version = var.geff_image_version

  snowalert_warehouse_size = var.snowalert_warehouse_size
  snowflake_integration_user_roles = [
    var.ingest_role,
    var.alerting_role,
    var.modeling_role,
  ]

  snowalert_warehouse_name = var.snowalert_warehouse_name
  snowalert_database_name  = var.snowalert_database_name

  alerts_merge_schedule    = var.alerts_merge_schedule
  alert_dispatch_schedule  = var.alert_dispatch_schedule
  alert_scheduler_schedule = var.alert_scheduler_schedule

  create_tables = var.create_tables

  integration_role = var.integration_role
  admin_role       = var.admin_role
  alerting_role    = var.alerting_role
  ingest_role      = var.ingest_role
  modeling_role    = var.modeling_role
  monitoring_role  = var.monitoring_role

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
    snowflake.api_integration_role     = snowflake.api_integration_role
    snowflake.storage_integration_role = snowflake.storage_integration_role
    snowflake.admin_role               = snowflake.admin_role
    snowflake.alerting_role            = snowflake.alerting_role
    aws                                = aws
  }
}
