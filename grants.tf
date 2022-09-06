module "snowalert_grants" {
  source = "git@github.com:Snowflake-Labs/terraform-snowflake-snowalert-rbac.git"

  snowalert_warehouse_name = var.snowalert_warehouse_name
  snowalert_database_name  = var.snowalert_database_name

  security_ingest_role     = var.security_ingest_role
  security_alerting_role   = var.security_alerting_role
  security_modeling_role   = var.security_modeling_role
  security_monitoring_role = var.security_monitoring_role
  app_snowalert_role       = var.snowalert_user_name

  # Schemas
  data_schema_name       = local.data_schema
  rules_schema_name      = local.rules_schema
  results_schema_name    = local.results_schema
  monitoring_schema_name = local.monitoring_schema

  providers = {
    snowflake.security_admin_role = snowflake.security_admin_role
  }
}
