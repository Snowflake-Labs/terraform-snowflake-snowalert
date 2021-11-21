resource "snowflake_view" "rule_tags" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "rule_tags"

  statement  = templatefile("${path.module}/views_sql/rule_tags.sql.tpl", {})
  or_replace = true
  is_secure  = false
}

resource "snowflake_view" "alerts" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "alerts"
  comment  = "Reflects on existing Alerts, e.g. for writing alert suppressions"

  statement  = templatefile("${path.module}/views_sql/alerts.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "violations" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "violations"
  comment  = "Reflects on existing Violations, e.g. for violation suppressions"

  statement  = templatefile("${path.module}/views_sql/alerts.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "tags_foj_alerts" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "tags_foj_alerts"
  comment  = "this view selects all tags, FOJed on alerts generated from queries having those tags."

  statement  = templatefile("${path.module}/views_sql/tags_foj_alerts.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "tags_foj_violations" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "tags_foj_violations"
  comment  = "this view selects all tags, FOJed on violations generated from queries having those tags."

  statement  = templatefile("${path.module}/views_sql/tags_foj_violations.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "alert_queries_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "alert_queries_runs"
  comment  = "Stable interface to underlying metadata tables."

  statement  = templatefile("${path.module}/views_sql/alert_queries_runs.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "alert_query_rule_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "alert_query_rule_runs"
  comment  = "Stable interface to underlying metadata tables."

  statement  = templatefile("${path.module}/views_sql/alert_query_rule_runs.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "alert_suppressions_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "alert_suppressions_runs"
  comment  = "Stable interface to underlying metadata tables."

  statement  = templatefile("${path.module}/views_sql/alert_suppressions_runs.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "alert_suppression_rule_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "alert_suppression_rule_runs"
  comment  = "Stable interface to underlying metadata tables."

  statement  = templatefile("${path.module}/views_sql/alert_suppression_rule_runs.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "violation_queries_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "violation_queries_runs"
  comment  = "Stable interface to underlying metadata tables."

  statement  = templatefile("${path.module}/views_sql/violation_queries_runs.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "violation_query_rule_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "violation_query_rule_runs"
  comment  = "Stable interface to underlying metadata tables."

  statement  = templatefile("${path.module}/views_sql/violation_query_rule_runs.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "violation_suppressions_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "violation_suppressions_runs"
  comment  = "Stable interface to underlying metadata tables."

  statement  = templatefile("${path.module}/views_sql/violation_suppressions_runs.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "violation_suppression_rule_runs" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "violation_suppression_rule_runs"
  comment  = "Stable interface to underlying metadata tables."

  statement  = templatefile("${path.module}/views_sql/violation_suppression_rule_runs.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "rule_views_to_titles_map" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "rule_views_to_titles_map"
  comment  = "Maps rules views to their titles for easy joining."

  statement  = templatefile("${path.module}/views_sql/rule_views_to_titles_map.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "alert_query_rule_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "alert_query_rule_run_errors"
  comment  = "Alert Query rule runs joined on errors."

  statement  = templatefile("${path.module}/views_sql/alert_query_rule_run_errors.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "alert_suppression_rule_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "alert_suppression_rule_run_errors"
  comment  = "Alert Query rule runs joined on errors."

  statement  = templatefile("${path.module}/views_sql/alert_suppression_rule_run_errors.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "violation_query_rule_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "violation_query_rule_run_errors"
  comment  = "Violation Query rule runs joined on errors."

  statement  = templatefile("${path.module}/views_sql/violation_query_rule_run_errors.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "violation_suppression_rule_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "violation_suppression_rule_run_errors"
  comment  = "Violation Query rule runs joined on errors."

  statement  = templatefile("${path.module}/views_sql/violation_suppression_rule_run_errors.sql.tpl", {})
  or_replace = true
}

resource "snowflake_view" "data_connector_run_errors" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "data_connector_run_errors"
  comment  = "Violation Query rule runs joined on errors."

  statement  = templatefile("${path.module}/views_sql/data_connector_run_errors.sql.tpl", {})
  or_replace = true
}
