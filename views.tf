resource "snowflake_view" "rule_tags" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "RULE_TAGS"

  statement  = templatefile("${path.module}/views_sql/rule_tags.sql", {})
  or_replace = true
  is_secure  = false
}

resource "snowflake_view" "alerts" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "ALERTS"
  comment  = "Reflects on existing Alerts, e.g. for writing alert suppressions"

  statement = templatefile(
    "${path.module}/views_sql/alerts.sql",
    {
      results_alerts = join(".", [
        snowflake_database.snowalert.name,
        snowflake_schema.results.name,
        snowflake_table.alerts.name,
      ])
    }
  )
  or_replace = true
}

resource "snowflake_view" "violations" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "VIOLATIONS"
  comment  = "Reflects on existing Violations, e.g. for violation suppressions"

  statement = templatefile(
    "${path.module}/views_sql/violations.sql",
    {
      results_violations = join(".", [
        snowflake_database.snowalert.name,
        snowflake_schema.results.name,
        snowflake_table.violations.name,
      ])
    }
  )
  or_replace = true
}

resource "snowflake_view" "tags_foj_alerts" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "TAGS_FOJ_ALERTS"
  comment  = "this view selects all tags, FOJed on alerts generated from queries having those tags."

  statement = templatefile(
    "${path.module}/views_sql/tags_foj_alerts.sql",
    {
      data_rule_tags = join(".", [
        snowflake_database.snowalert.name,
        snowflake_schema.data.name,
        snowflake_view.rule_tags.name,
      ])
      data_alerts = join(".", [
        snowflake_database.snowalert.name,
        snowflake_schema.data.name,
        snowflake_view.alerts.name,
      ])
    }
  )
  or_replace = true
}

resource "snowflake_view" "tags_foj_violations" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "TAGS_FOJ_VIOLATIONS"
  comment  = "this view selects all tags, FOJed on violations generated from queries having those tags."

  statement = templatefile(
    "${path.module}/views_sql/tags_foj_violations.sql",
    {
      data_rule_tags = join(".", [
        snowflake_database.snowalert.name,
        snowflake_schema.data.name,
        snowflake_view.rule_tags.name,
      ])
      data_violations = join(".", [
        snowflake_database.snowalert.name,
        snowflake_schema.data.name,
        snowflake_view.violations.name,
      ])
    }
  )
  or_replace = true
}

locals {
  results_run_metadata = join(".", [
    snowflake_database.snowalert.name,
    snowflake_schema.results.name,
    snowflake_table.run_metadata.name,
  ])

  results_query_metadata = join(".", [
    snowflake_database.snowalert.name,
    snowflake_schema.results.name,
    snowflake_table.query_metadata.name,
  ])
}

resource "snowflake_view" "alert_queries_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "ALERT_QUERIES_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/alert_queries_runs.sql",
    { results_run_metadata = local.results_run_metadata }
  )
  or_replace = true
}

resource "snowflake_view" "alert_query_rule_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "ALERT_QUERY_RULE_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/alert_query_rule_runs.sql",
    { results_query_metadata = local.results_query_metadata }
  )
  or_replace = true
}

resource "snowflake_view" "alert_suppressions_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "ALERT_SUPPRESSIONS_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/alert_suppressions_runs.sql",
    { results_run_metadata = local.results_run_metadata }
  )
  or_replace = true
}

resource "snowflake_view" "alert_suppression_rule_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "ALERT_SUPPRESSION_RULE_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/alert_suppression_rule_runs.sql",
    { results_query_metadata = local.results_query_metadata }
  )
  or_replace = true
}

resource "snowflake_view" "violation_queries_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "VIOLATION_QUERIES_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/violation_queries_runs.sql",
    { results_run_metadata = local.results_run_metadata }
  )
  or_replace = true
}

resource "snowflake_view" "violation_query_rule_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "VIOLATION_QUERY_RULE_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/violation_query_rule_runs.sql",
    { results_query_metadata = local.results_query_metadata }
  )
  or_replace = true
}

resource "snowflake_view" "violation_suppressions_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "VIOLATION_SUPPRESSIONS_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/violation_suppressions_runs.sql",
    { results_run_metadata = local.results_run_metadata }
  )
  or_replace = true
}

resource "snowflake_view" "violation_suppression_rule_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "VIOLATION_SUPPRESSION_RULE_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/violation_suppression_rule_runs.sql",
    { results_query_metadata = local.results_query_metadata }
  )
  or_replace = true
}

resource "snowflake_view" "rule_views_to_titles_map" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "RULE_VIEWS_TO_TITLES_MAP"
  comment  = "Maps rules views to their titles for easy joining."

  statement  = templatefile("${path.module}/views_sql/rule_views_to_titles_map.sql", {})
  or_replace = true
}

locals {
  data_alert_query_rule_runs = join(".", [
    snowflake_database.snowalert.name,
    snowflake_schema.data.name,
    snowflake_view.alert_query_rule_runs.name,
  ])

  data_alert_suppression_rule_runs = join(".", [
    snowflake_database.snowalert.name,
    snowflake_schema.data.name,
    snowflake_view.alert_suppression_rule_runs.name,
  ])

  data_violation_query_rule_runs = join(".", [
    snowflake_database.snowalert.name,
    snowflake_schema.data.name,
    snowflake_view.violation_query_rule_runs.name,
  ])

  data_violation_suppression_rule_runs = join(".", [
    snowflake_database.snowalert.name,
    snowflake_schema.data.name,
    snowflake_view.violation_suppression_rule_runs.name,
  ])

  data_rule_views_to_titles_map = join(".", [
    snowflake_database.snowalert.name,
    snowflake_schema.data.name,
    snowflake_view.rule_views_to_titles_map.name,
  ])

  data_time_slices_before_t = join(".", [
    snowflake_database.snowalert.name,
    snowflake_schema.data.name,
    snowflake_function.time_slices_before_t_with_t.name,
  ])
}

resource "snowflake_view" "alert_query_rule_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "ALERT_QUERY_RULE_RUN_ERRORS"
  comment  = "Alert Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/alert_query_rule_run_errors.sql", {
      data_alert_query_rule_runs    = local.data_alert_query_rule_runs
      data_rule_views_to_titles_map = local.data_rule_views_to_titles_map
    }
  )
  or_replace = true
}

resource "snowflake_view" "alert_suppression_rule_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "ALERT_SUPPRESSION_RULE_RUN_ERRORS"
  comment  = "Alert Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/alert_suppression_rule_run_errors.sql", {
      data_alert_suppression_rule_runs = local.data_alert_suppression_rule_runs
      data_rule_views_to_titles_map    = local.data_rule_views_to_titles_map
    }
  )
  or_replace = true
}

resource "snowflake_view" "violation_query_rule_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "VIOLATION_QUERY_RULE_RUN_ERRORS"
  comment  = "Violation Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/violation_query_rule_run_errors.sql", {
      data_violation_query_rule_runs = local.data_violation_query_rule_runs
      data_rule_views_to_titles_map  = local.data_rule_views_to_titles_map
    }
  )
  or_replace = true
}

resource "snowflake_view" "violation_suppression_rule_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "VIOLATION_SUPPRESSION_RULE_RUN_ERRORS"
  comment  = "Violation Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/violation_suppression_rule_run_errors.sql", {
      data_violation_suppression_rule_runs = local.data_violation_suppression_rule_runs
      data_rule_views_to_titles_map        = local.data_rule_views_to_titles_map
    }
  )
  or_replace = true
}

resource "snowflake_view" "data_connector_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "DATA_CONNECTOR_RUN_ERRORS"
  comment  = "Violation Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/data_connector_run_errors.sql", {
      data_time_slices_before_t = local.data_time_slices_before_t
    }
  )
  or_replace = true
}