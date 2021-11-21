# CREATE DATABASE IF NOT EXISTS {database};
resource "snowflake_database" "snowalert" {
  name    = var.db_name
  comment = "Snowalert Database."
}
