# CREATE ROLE IF NOT EXISTS {role};
resource "snowflake_role" "snowalert" {
  name    = var.snowalert_role_name
  comment = "The role that all Snowalert objects are granted to."
}
