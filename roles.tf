# CREATE ROLE IF NOT EXISTS {role};
resource "snowflake_role" "snowalert" {
  name    = var.snowalert_role_name
  comment = "A Snowalert role."
}
