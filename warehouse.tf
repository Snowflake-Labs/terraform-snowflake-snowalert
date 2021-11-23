
# CREATE WAREHOUSE IF NOT EXISTS {warehouse}
# WAREHOUSE_SIZE=
# WAREHOUSE_TYPE=
# AUTO_SUSPEND=60
# AUTO_RESUME=TRUE
# INITIALLY_SUSPENDED=TRUE
# ;

resource "snowflake_warehouse" "w" {
  name           = var.warehouse
  type           = "STANDARD"
  comment        = "foo"
  warehouse_size = "XSMALL"

  auto_suspend = 60
  auto_resume  = true
}
