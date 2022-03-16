resource "snowflake_task" "snowalert_alert_merge_task" {
  provider = snowflake.admin_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "ALERT_MERGE"

  schedule      = "USING CRON 0 12 * * * UTC"
  sql_statement = "CALL ${local.snowalert_database_name}.${local.results_schema}.${snowflake_procedure.alert_merge.name}('30m')"
  enabled       = true

  // This is a workeraound for a known bug https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/204
  lifecycle {
    ignore_changes = [session_parameters, sql_statement]
  }
}

resource "snowflake_task" "snowalert_suppression_merge_task" {
  provider = snowflake.admin_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "SUPPRESSION_MERGE"

  after         = snowflake_task.snowalert_alert_merge_task.name
  sql_statement = "CALL ${local.snowalert_database_name}.${local.results_schema}.${snowflake_procedure.alert_suppressions_runner_without_queries_like.name}()"
  enabled       = true

  // This is a workeraound for a known bug https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/204
  lifecycle {
    ignore_changes = [session_parameters, sql_statement]
  }
}
