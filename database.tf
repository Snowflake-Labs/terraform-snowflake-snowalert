# CREATE DATABASE IF NOT EXISTS {database};
resource "snowflake_database" "snowalert" {
  provider = snowflake.admin

  name    = var.snowalert_db_name
  comment = "Snowalert Database."
}
