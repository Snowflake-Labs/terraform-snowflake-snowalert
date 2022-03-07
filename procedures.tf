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
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_DISPATCHER"

  return_type = "VARIANT"
  execute_as  = "CALLER"
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
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_MERGE"

  arguments {
    name = "deduplication_offset"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
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
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_PROCESSOR"

  return_type = "VARIANT"
  execute_as  = "CALLER"
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
resource "snowflake_procedure" "alert_queries_runner_with_time" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_QUERIES_RUNNER"

  arguments {
    name = "query_name"
    type = "VARCHAR"
  }

  arguments {
    name = "from_time_sql"
    type = "VARCHAR"
  }

  arguments {
    name = "to_time_sql"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement   = templatefile("${path.module}/procedures_js/alert_queries_runner.js", {})
}

# CREATE OR REPLACE PROCEDURE results.alert_queries_runner(query_name STRING, offset STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-queries-runner.js'
# ;
resource "snowflake_procedure" "alert_queries_runner_without_time" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_QUERIES_RUNNER"

  arguments {
    name = "query_name"
    type = "VARCHAR"
  }

  arguments {
    name = "offset"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement   = templatefile("${path.module}/procedures_js/alert_queries_runner.js", {})
}

# CREATE OR REPLACE PROCEDURE results.alert_queries_runner(query_name STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-queries-runner.js'
# ;
resource "snowflake_procedure" "alert_queries_runner" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_QUERIES_RUNNER"

  arguments {
    name = "query_name"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
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
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_SCHEDULER"

  arguments {
    name = "warehouse"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
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
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_SUPPRESSIONS_RUNNER"

  arguments {
    name = "queries_like"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement   = templatefile("${path.module}/procedures_js/alert_suppressions_runner.js", {})
}

# CREATE OR REPLACE PROCEDURE results.alert_suppressions_runner()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-suppressions-runner.js'
# ;
resource "snowflake_procedure" "alert_suppressions_runner_without_queries_like" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERT_SUPPRESSIONS_RUNNER"

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement   = templatefile("${path.module}/procedures_js/alert_suppressions_runner.js", {})
}

# ---------------------------
# 7. Violation Queries Runner
# ---------------------------
# CREATE OR REPLACE PROCEDURE results.violation_queries_runner()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-violation-queries-runner.js'
# ;
resource "snowflake_procedure" "violation_queries_runner" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "VIOLATION_QUERIES_RUNNER"

  return_type = "VARIANT"
  execute_as  = "CALLER"
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
