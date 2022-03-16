resource "snowflake_stream" "raw_alerts_stream" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.rules_schema
  name     = "RAW_ALERTS_STREAM"

  on_table = join(".", [
    local.snowalert_database_name,
    local.results_schema,
    local.raw_alerts_table,
  ])
  comment = "A stream to track the diffs on raw_alerts table."
}
