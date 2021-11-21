# CREATE USER IF NOT EXISTS {user} {user_defaults};

resource "snowflake_user" "user" {
  name         = "Snowflake User"
  login_name   = "snowflake_user"
  comment      = "A user of snowflake."
  disabled     = false
  display_name = "Snowflake User"
  email        = "user@snowflake.example"
  first_name   = "Snowflake"
  last_name    = "User"

  default_warehouse = "warehouse"
  default_role      = "role1"

  must_change_password = false
}
