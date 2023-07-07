# Warehouse
resource "snowflake_warehouse" "snowalert" {
  count    = var.create_warehouse == true ? 1 : 0
  provider = snowflake.admin_role

  name           = upper(trimspace(var.snowalert_warehouse_name))
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
  provider = snowflake.admin_role

  name    = upper(trimspace(var.snowalert_database_name))
  comment = "Snowalert Database."
}

locals {
  snowalert_database_name = var.snowalert_database_name == true ? snowflake_database.snowalert[0].name : var.snowalert_database_name
}

