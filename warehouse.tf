# CREATE WAREHOUSE IF NOT EXISTS {warehouse}
# WAREHOUSE_SIZE=
# WAREHOUSE_TYPE=
# AUTO_SUSPEND=60
# AUTO_RESUME=TRUE
# INITIALLY_SUSPENDED=TRUE
# ;
resource "snowflake_warehouse" "snowalert" {
  name           = var.snowalert_warehouse_name
  comment        = "Warehouse that will be used for Snowalert."
  warehouse_size = "X-Small"

  auto_suspend = 60
  auto_resume  = true
}
