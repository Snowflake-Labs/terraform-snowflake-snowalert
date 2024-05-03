resource "snowflake_task" "snowalert_alerts_merge_task" {
  provider = snowflake.alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "ALERTS_MERGE"

  schedule      = "USING CRON ${var.alerts_merge_schedule} UTC"
  sql_statement = "CALL ${local.results_schema}.${snowflake_procedure.alerts_merge.name}('30m')"
  enabled       = true

  suspend_task_after_num_failures = 0

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_task" "snowalert_suppression_merge_task" {
  provider = snowflake.alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "SUPPRESSION_MERGE"

  after         = [snowflake_task.snowalert_alerts_merge_task.name]
  sql_statement = "CALL ${local.snowalert_database_name}.${local.results_schema}.${snowflake_procedure.alert_suppressions_runner_without_queries_like.name}()"
  enabled       = true

  suspend_task_after_num_failures = 0

  depends_on = [
    module.snowalert_grants
  ]
}


resource "snowflake_task" "alert_processor_task" {
  provider = snowflake.alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "ALERT_PROCESSOR"

  after         = [snowflake_task.snowalert_suppression_merge_task.name]
  sql_statement = "CALL ${local.results_schema}.${snowflake_procedure.alert_processor_with_default_correlation_period.name}()"
  enabled       = true

  suspend_task_after_num_failures = 0

  depends_on = [
    module.snowalert_grants
  ]
}


resource "snowflake_task" "alert_dispatcher_task" {
  provider = snowflake.alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "ALERT_DISPATCHER"

  schedule      = "USING CRON ${var.alert_dispatch_schedule} UTC"
  sql_statement = "CALL ${local.results_schema}.${snowflake_procedure.alert_dispatcher.name}()"
  enabled       = true

  suspend_task_after_num_failures = 0

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_task" "alert_scheduler_task" {
  provider = snowflake.alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "ALERT_SCHEDULER"

  schedule      = "USING CRON ${var.alert_scheduler_schedule} UTC"
  sql_statement = "CALL ${local.results_schema}.${snowflake_procedure.alert_scheduler.name}('${local.snowalert_warehouse_name}')"
  enabled       = true

  suspend_task_after_num_failures = 0

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_task" "violation_scheduler_task" {
  provider = snowflake.alerting_role

  warehouse = local.snowalert_warehouse_name
  database  = local.snowalert_database_name
  schema    = local.results_schema
  name      = "VIOLATION_SCHEDULER"

  suspend_task_after_num_failures = 0

  schedule      = "USING CRON ${var.violation_scheduler_schedule} UTC"
  sql_statement = "CALL ${local.results_schema}.${snowflake_procedure.violation_scheduler.name}('${local.snowalert_warehouse_name}')"
  enabled       = true

  depends_on = [
    module.snowalert_grants
  ]
}
