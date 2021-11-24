# CREATE DATABASE IF NOT EXISTS {database};
resource "snowflake_database" "snowalert" {
  name    = var.snowalert_db_name
  comment = "Snowalert Database."
}
