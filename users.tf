# CREATE USER IF NOT EXISTS {user} {user_defaults};

resource "snowflake_user" "user" {
  name       = "Snowalert User"
  login_name = "app_snowalert"
  # make the above unique, if prompted with object already exists

  display_name = "Snowalert User"
  email        = "snowalert@snowflake.com"
  first_name   = "Snowalert"
  last_name    = "User"

  default_warehouse    = snowflake_warehouse.snowalert.name
  default_role         = snowflake_role.snowalert.name
  must_change_password = false
  disabled             = false
}
