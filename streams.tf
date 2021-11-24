# CREATE STREAM IF NOT EXISTS results.raw_alerts_stream
# ON TABLE results.raw_alerts
# ;
resource "snowflake_stream" "stream" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.rules.name
  name     = "raw_alerts_stream"

  on_table = snowflake_table.raw_alerts.name
  owner    = var.role

  comment = "A stream to track the diffs on raw_alerts table."
}
