locals {
  data_schema_name       = "DATA"
  rules_schema_name      = "RULES"
  results_schema_name    = "RESULTS"
  monitoring_schema_name = "MONITORING"
}

# Schemas
resource "snowflake_schema" "data" {
  count    = var.create_schemas == true ? 1 : 0
  provider = snowflake.admin_role

  database = local.snowalert_database_name
  name     = local.data_schema_name
}

locals {
  data_schema = var.create_schemas == true ? snowflake_schema.data[0].name : local.data_schema_name
}

resource "snowflake_schema" "rules" {
  count    = var.create_schemas == true ? 1 : 0
  provider = snowflake.admin_role

  database = local.snowalert_database_name
  name     = local.rules_schema_name
}

locals {
  rules_schema = var.create_schemas == true ? snowflake_schema.rules[0].name : local.rules_schema_name
}

resource "snowflake_schema" "results" {
  count    = var.create_schemas == true ? 1 : 0
  provider = snowflake.admin_role

  database = local.snowalert_database_name
  name     = local.results_schema_name
}

resource "snowflake_object_parameter" "results_schema_suspend_task_after_num_failures" {
  count    = var.create_schemas == true ? 1 : 0
  provider = snowflake.admin_role

  key         = "SUSPEND_TASK_AFTER_NUM_FAILURES"
  value       = "0"
  object_type = "SCHEMA"

  object_identifier {
    database = local.snowalert_database_name
    name     = local.results_schema
  }
}

locals {
  results_schema = var.create_schemas == true ? snowflake_schema.results[0].name : local.results_schema_name
}

resource "snowflake_schema" "monitoring" {
  count    = var.create_schemas == true ? 1 : 0
  provider = snowflake.admin_role

  database = local.snowalert_database_name
  name     = local.monitoring_schema_name
}

locals {
  monitoring_schema = var.create_schemas == true ? snowflake_schema.monitoring[0].name : local.monitoring_schema_name
}
