# CREATE USER IF NOT EXISTS {user} {user_defaults};
resource "snowflake_user" "user" {
  provider = snowflake.admin

  name       = "${var.prefix} Snowalert User"
  login_name = "${var.prefix}_APP_SNOWALERT"
  # make the above unique, if prompted with object already exists

  display_name = "${var.prefix} Snowalert User"
  email        = "snowalert@snowflake.com"
  first_name   = "${var.prefix} Snowalert"
  last_name    = "User"

  default_warehouse    = snowflake_warehouse.snowalert.name
  default_role         = snowflake_role.snowalert.name
  must_change_password = false
  disabled             = false
}
