resource "snowflake_task" "snowalert_alert_merge_task" {
  provider = snowflake.security_alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "ALERT_MERGE"

  schedule      = "USING CRON ${var.alert_merge_schedule} UTC"
  sql_statement = "CALL ${local.results_schema}.${snowflake_procedure.alert_merge.name}('30m')"
  enabled       = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_task" "snowalert_suppression_merge_task" {
  provider = snowflake.security_alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "SUPPRESSION_MERGE"

  after         = snowflake_task.snowalert_alert_merge_task.name
  sql_statement = "CALL ${local.snowalert_database_name}.${local.results_schema}.${snowflake_procedure.alert_suppressions_runner_without_queries_like.name}()"
  enabled       = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_task" "alert_dispatcher_task" {
  provider = snowflake.security_alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "ALERT_DISPATCHER"

  schedule      = "USING CRON ${var.alert_dispatch_schedule} UTC"
  sql_statement = "CALL ${local.results_schema}.${snowflake_procedure.alert_dispatcher.name}()"
  enabled       = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_task" "alert_scheduler_task" {
  provider = snowflake.security_alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "ALERT_SCHEDULER"

  schedule      = "USING CRON ${var.alert_scheduler_schedule} UTC"
  sql_statement = "CALL ${local.results_schema}.${snowflake_procedure.alert_scheduler.name}('${local.snowalert_warehouse_name}')"
  enabled       = true

  depends_on = [
    module.snowalert_grants
  ]
}
