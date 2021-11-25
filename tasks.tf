# -- 1. Runs the alert queries merge
# CREATE OR REPLACE TASK results.alerts_merge
#   WAREHOUSE=snowalert_warehouse
#   SCHEDULE='USING CRON * * * * * UTC'
# AS
# CALL results.alerts_merge('30m')
# ;
resource "snowflake_task" "snowalert_alert_merge_task" {
  warehouse = snowflake_warehouse.snowalert.name
  database  = snowflake_database.snowalert.name
  schema    = snowflake_schema.results.name
  name      = "ALERT_MERGE"

  schedule      = "USING CRON 0 12 * * * UTC"
  sql_statement = "CALL ${snowflake_database.snowalert.name}.${snowflake_schema.results.name}.${snowflake_procedure.alert_merge.name}('30m')"
  enabled       = true

  // This is a workeraound for a known bug https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/204
  lifecycle {
    ignore_changes = [session_parameters, sql_statement]
  }
}

# -- 2. Runs the alerts supressions merge
# CREATE OR REPLACE TASK results.suppressions_merge 
#   WAREHOUSE=snowalert_warehouse
#   AFTER results.alerts_merge
# AS
# CALL results.alert_suppressions_runner()
# ;
resource "snowflake_task" "snowalert_suppression_merge_task" {
  warehouse = snowflake_warehouse.snowalert.name
  database  = snowflake_database.snowalert.name
  schema    = snowflake_schema.results.name
  name      = "SUPPRESSION_MERGE"

  after         = snowflake_task.snowalert_alert_merge_task.name
  sql_statement = "CALL ${snowflake_database.snowalert.name}.${snowflake_schema.results.name}.${snowflake_procedure.alert_suppressions_runner_without_queries_like.name}()"
  enabled       = true

  // This is a workeraound for a known bug https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/204
  lifecycle {
    ignore_changes = [session_parameters, sql_statement]
  }
}
