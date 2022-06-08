data "snowflake_role" "admin_role" {
  provider = snowflake.admin_role
  name     = "admin_role"
}

data "snowflake_role" "alerting_role" {
  provider = snowflake.alerting_role
  name     = "alerting_role"
}
