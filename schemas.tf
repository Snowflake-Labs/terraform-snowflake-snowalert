# CREATE SCHEMA IF NOT EXISTS data;
# CREATE SCHEMA IF NOT EXISTS rules;
# CREATE SCHEMA IF NOT EXISTS results;

resource "snowflake_schema" "data" {
  database = snowflake_database.snowalert.name
  name     = "DATA"
}

resource "snowflake_schema" "rules" {
  database = snowflake_database.snowalert.name
  name     = "RULES"
}

resource "snowflake_schema" "results" {
  database = snowflake_database.snowalert.name
  name     = "RESULTS"
}
