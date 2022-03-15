# Warehouse
resource "snowflake_warehouse" "snowalert" {
  provider = snowflake.admin
  count    = var.create_warehouse == true ? 1 : 0

  name           = var.snowalert_warehouse_name
  comment        = "Warehouse that will be used for Snowalert."
  warehouse_size = var.snowalert_warehouse_size

  auto_suspend = 60
  auto_resume  = true
}

locals {
  snowalert_warehouse_name = var.create_warehouse == true ? snowflake_warehouse.snowalert[0].name : var.snowalert_warehouse_name
}

# Database
resource "snowflake_database" "snowalert" {
  count    = var.create_database == true ? 1 : 0
  provider = snowflake.admin

  name    = var.snowalert_database_name
  comment = "Snowalert Database."
}

locals {
  snowalert_database_name = var.snowalert_database_name == true ? snowflake_database.snowalert[0].name : var.snowalert_database_name
}

locals {
  first_name = "${upper(trimspace(var.prefix))} Snowalert"
  last_name  = "User"
}

locals {
  full_name = "${local.first_name} ${local.last_name}"
}

# User
resource "snowflake_user" "snowalert" {
  count    = var.create_user == true ? 1 : 0
  provider = snowflake.admin

  # Make sure the name is unique, if prompted with object already exists
  login_name = "${upper(trimspace(var.prefix))}_APP_SNOWALERT"
  name       = local.full_name

  display_name = local.full_name
  email        = var.snowalert_user_email
  first_name   = local.first_name
  last_name    = local.last_name

  default_warehouse    = local.snowalert_warehouse_name
  default_role         = local.snowalert_role_name
  must_change_password = false
  disabled             = false
}

locals {
  snowalert_user_name = var.create_user == true ? snowflake_user.snowalert[0].name : var.snowalert_user_name
}

# Role
resource "snowflake_role" "snowalert" {
  count    = var.create_role == true ? 1 : 0
  provider = snowflake.admin

  name    = upper(trimspace(var.snowalert_role_name))
  comment = "The role that all Snowalert objects are granted to."
}

locals {
  snowalert_role_name = var.create_role == true ? snowflake_role.snowalert[0].name : var.snowalert_role_name
}

# Schemas
resource "snowflake_schema" "data" {
  count    = var.create_schemas == true ? 1 : 0
  provider = snowflake.admin

  database = local.snowalert_database_name
  name     = var.data_schema_name
}

locals {
  data_schema = var.create_schemas == true ? snowflake_schema.data[0].name : var.data_schema_name
}

resource "snowflake_schema" "rules" {
  count    = var.create_schemas == true ? 1 : 0
  provider = snowflake.admin

  database = local.snowalert_database_name
  name     = var.rules_schema_name
}

locals {
  rules_schema = var.create_schemas == true ? snowflake_schema.rules[0].name : var.rules_schema_name
}

resource "snowflake_schema" "results" {
  count    = var.create_schemas == true ? 1 : 0
  provider = snowflake.admin

  database = local.snowalert_database_name
  name     = var.results_schema_name
}

locals {
  results_schema = var.create_schemas == true ? snowflake_schema.results[0].name : var.results_schema_name
}
