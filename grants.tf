module "snowalert_grants" {
  source = "git@github.com:Snowflake-Labs/terraform-snowflake-snowalert-rbac.git"

  snowalert_warehouse_name = var.snowalert_warehouse_name
  snowalert_database_name  = var.snowalert_database_name

  ingest_role        = var.ingest_role
  alerting_role      = var.alerting_role
  modeling_role      = var.modeling_role
  monitoring_role    = var.monitoring_role
  snowalert_app_role = var.snowalert_app_role

  # Schemas
  data_schema_name       = local.data_schema
  rules_schema_name      = local.rules_schema
  results_schema_name    = local.results_schema
  monitoring_schema_name = local.monitoring_schema

  providers = {
    snowflake.admin_role = snowflake.admin_role
    aws                  = aws
  }
}
