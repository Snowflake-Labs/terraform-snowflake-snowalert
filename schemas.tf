# CREATE SCHEMA IF NOT EXISTS data;
# CREATE SCHEMA IF NOT EXISTS rules;
# CREATE SCHEMA IF NOT EXISTS results;

resource "snowflake_schema" "data" {
  database = snowflake_database.snowalert.name
  name     = "DATA"

  #   comment  = "."
  #   is_transient        = false
  #   is_managed          = false
  #   data_retention_days = 1
}

resource "snowflake_schema" "rules" {
  database = snowflake_database.snowalert.name
  name     = "RULES"

  #   comment  = "."
  #   is_transient        = false
  #   is_managed          = false
  #   data_retention_days = 1
}

resource "snowflake_schema" "results" {
  database = snowflake_database.snowalert.name
  name     = "RESULTS"

  #   comment  = "."
  #   is_transient        = false
  #   is_managed          = false
  #   data_retention_days = 1
}
