# ------------------
# 1. Alert Dispatcher
# ------------------
# CREATE OR REPLACE PROCEDURE results.alert_dispatcher()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-dispatcher.js'
# ;
resource "snowflake_procedure" "alert_dispatcher" {
  name     = "alert_dispatcher"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_dispatcher.js", {})
}

# -------------------------
# 2. deduplicator or merger
# -------------------------
# CREATE OR REPLACE PROCEDURE results.alert_merge(deduplication_offset STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-merge.js'
# ;
resource "snowflake_procedure" "alert_merge" {
  name     = "alert_merge"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  arg {
    name = "deduplication_offset"
    type = "STRING"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_merge.js", {})
}

# -------------------------
# 3. processor
# -------------------------
# CREATE OR REPLACE PROCEDURE results.alert_processor()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-processor.js'
# ;
resource "snowflake_procedure" "alert_processor" {
  name     = "alert_processor"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_processor.js", {})
}

# -------------------------
# 4. Alert Query Runner
# -------------------------
# CREATE OR REPLACE PROCEDURE results.alert_queries_runner(query_name STRING, from_time_sql STRING, to_time_sql STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-queries-runner.js'
# ;
resource "snowflake_procedure" "alert_queries_runner" {
  name     = "alert_queries_runner"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  arg {
    name = "query_name"
    type = "STRING"
  }

  arg {
    name = "from_time_sql"
    type = "STRING"
  }

  arg {
    name = "to_time_sql"
    type = "STRING"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_queries_runner.js", {})
}

# CREATE OR REPLACE PROCEDURE results.alert_queries_runner(query_name STRING, offset STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-queries-runner.js'
# ;
resource "snowflake_procedure" "alert_queries_runner" {
  name     = "alert_queries_runner"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  arg {
    name = "query_name"
    type = "STRING"
  }

  arg {
    name = "offset"
    type = "STRING"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_queries_runner.js", {})
}

# CREATE OR REPLACE PROCEDURE results.alert_queries_runner(query_name STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-queries-runner.js'
# ;
resource "snowflake_procedure" "alert_queries_runner" {
  name     = "alert_queries_runner"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  arg {
    name = "query_name"
    type = "STRING"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_queries_runner.js", {})
}

# -------------------------
# 5. Alert Scheduler
# -------------------------
# CREATE OR REPLACE PROCEDURE results.alert_scheduler(warehouse STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-scheduler.js'
# ;
resource "snowflake_procedure" "alert_scheduler" {
  name     = "alert_scheduler"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  arg {
    name = "warehouse"
    type = "STRING"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_scheduler.js", {})
}

# ---------------------------
# 6. Alert Suppressions Runner
# ---------------------------
# CREATE OR REPLACE PROCEDURE results.alert_suppressions_runner(queries_like STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-suppressions-runner.js'
# ;
resource "snowflake_procedure" "alert_suppressions_runner" {
  name     = "alert_suppressions_runner"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  arg {
    name = "queries_like"
    type = "STRING"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_suppressions_runner.js", {})
}

# CREATE OR REPLACE PROCEDURE results.alert_suppressions_runner()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-suppressions-runner.js'
# ;
resource "snowflake_procedure" "alert_suppressions_runner" {
  name     = "alert_suppressions_runner"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_suppressions_runner.js", {})
}

# ---------------------------
# 7. Violation Queries Runner
# ---------------------------
# CREATE OR REPLACE PROCEDURE results.alert_suppressions_runner(queries_like STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-suppressions-runner.js'
# ;
resource "snowflake_procedure" "alert_suppressions_runner" {
  name     = "alert_suppressions_runner"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  arg {
    name = "queries_like"
    type = "STRING"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/alert_suppressions_runner.js", {})
}

# CREATE OR REPLACE PROCEDURE results.violation_queries_runner()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-violation-queries-runner.js'
# ;
resource "snowflake_procedure" "violation_queries_runner" {
  name     = "violation_queries_runner"
  database = snowflake_database.db.name
  schema   = snowflake_schema.results.name

  return_type = "VARIANT"
  execute_as  = "CALLER"
  language    = "JAVASCRIPT"
  statement   = templatefile("${path.module}/procedures_js/violation_queries_runner.js", {})
}

# --------------------------------
# 8. Violation Suppressions Runner
# --------------------------------
# CREATE OR REPLACE PROCEDURE results.violation_suppressions_runner()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-violation-suppressions-runner.js'
# ;
