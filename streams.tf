resource "snowflake_stream" "raw_alerts_stream" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.rules.name
  name     = "raw_alerts_stream"

  on_table = join(".", [
    local.snowalert_database_name,
    snowflake_schema.results.name,
    snowflake_table.raw_alerts.name,
  ])
  comment = "A stream to track the diffs on raw_alerts table."
}
