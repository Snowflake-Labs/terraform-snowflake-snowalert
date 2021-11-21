# CREATE ROLE IF NOT EXISTS {role};
resource "snowflake_role" "snowalert" {
  name    = var.role
  comment = "Snowalert role."
}
