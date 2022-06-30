resource "snowflake_view" "rule_tags" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "RULE_TAGS"

  statement = templatefile(
    "${path.module}/views_sql/rule_tags.sql", {
      rules_schema = local.rules_schema
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "alerts" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "ALERTS"
  comment  = "Reflects on existing Alerts, e.g. for writing alert suppressions"

  statement = templatefile(
    "${path.module}/views_sql/alerts.sql",
    {
      results_alerts_table = join(".", [
        local.snowalert_database_name,
        local.results_schema,
        local.alerts_table,
      ])
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "violations" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "VIOLATIONS"
  comment  = "Reflects on existing Violations, e.g. for violation suppressions"

  statement = templatefile(
    "${path.module}/views_sql/violations.sql",
    {
      results_violations = join(".", [
        local.snowalert_database_name,
        local.results_schema,
        local.violations_table,
      ])
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "tags_foj_alerts" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "TAGS_FOJ_ALERTS"
  comment  = "this view selects all tags, FOJed on alerts generated from queries having those tags."

  statement = templatefile(
    "${path.module}/views_sql/tags_foj_alerts.sql",
    {
      data_rule_tags = join(".", [
        local.snowalert_database_name,
        local.data_schema,
        snowflake_view.rule_tags.name,
      ])
      data_alerts = join(".", [
        local.snowalert_database_name,
        local.data_schema,
        snowflake_view.alerts.name,
      ])
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "tags_foj_violations" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "TAGS_FOJ_VIOLATIONS"
  comment  = "this view selects all tags, FOJed on violations generated from queries having those tags."

  statement = templatefile(
    "${path.module}/views_sql/tags_foj_violations.sql",
    {
      data_rule_tags = join(".", [
        local.snowalert_database_name,
        local.data_schema,
        snowflake_view.rule_tags.name,
      ])
      data_violations = join(".", [
        local.snowalert_database_name,
        local.data_schema,
        snowflake_view.violations.name,
      ])
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  results_run_metadata = join(".", [
    local.snowalert_database_name,
    local.results_schema,
    local.run_metadata_table,
  ])

  results_query_metadata = join(".", [
    local.snowalert_database_name,
    local.results_schema,
    local.query_metadata_table,
  ])
}

resource "snowflake_view" "alert_queries_runs" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "ALERT_QUERIES_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/alert_queries_runs.sql",
    { results_run_metadata = local.results_run_metadata }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "alert_query_rule_runs" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "ALERT_QUERY_RULE_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/alert_query_rule_runs.sql",
    { results_query_metadata = local.results_query_metadata }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "alert_suppressions_runs" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "ALERT_SUPPRESSIONS_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/alert_suppressions_runs.sql",
    { results_run_metadata = local.results_run_metadata }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "alert_suppression_rule_runs" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "ALERT_SUPPRESSION_RULE_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/alert_suppression_rule_runs.sql",
    { results_query_metadata = local.results_query_metadata }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "violation_queries_runs" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "VIOLATION_QUERIES_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/violation_queries_runs.sql",
    { results_run_metadata = local.results_run_metadata }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "violation_query_rule_runs" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "VIOLATION_QUERY_RULE_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/violation_query_rule_runs.sql",
    { results_query_metadata = local.results_query_metadata }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "violation_suppressions_runs" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "VIOLATION_SUPPRESSIONS_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/violation_suppressions_runs.sql",
    { results_run_metadata = local.results_run_metadata }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "violation_suppression_rule_runs" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "VIOLATION_SUPPRESSION_RULE_RUNS"
  comment  = "Stable interface to underlying metadata tables."

  statement = templatefile(
    "${path.module}/views_sql/violation_suppression_rule_runs.sql",
    { results_query_metadata = local.results_query_metadata }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "rule_views_to_titles_map" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "RULE_VIEWS_TO_TITLES_MAP"
  comment  = "Maps rules views to their titles for easy joining."

  statement  = templatefile("${path.module}/views_sql/rule_views_to_titles_map.sql", {})
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  data_alert_query_rule_runs = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_view.alert_query_rule_runs.name,
  ])

  data_alert_suppression_rule_runs = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_view.alert_suppression_rule_runs.name,
  ])

  data_violation_query_rule_runs = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_view.violation_query_rule_runs.name,
  ])

  data_violation_suppression_rule_runs = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_view.violation_suppression_rule_runs.name,
  ])

  data_rule_views_to_titles_map = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_view.rule_views_to_titles_map.name,
  ])

  data_time_slices_before_t_without_time = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_function.time_slices_before_t_without_time.name,
  ])

  results_ingestion_metadata_table = join(".", [
    local.snowalert_database_name,
    local.results_schema,
    local.ingestion_metadata_table,
  ])
}

resource "snowflake_view" "alert_query_rule_run_errors" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "ALERT_QUERY_RULE_RUN_ERRORS"
  comment  = "Alert Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/alert_query_rule_run_errors.sql", {
      data_alert_query_rule_runs    = local.data_alert_query_rule_runs
      data_rule_views_to_titles_map = local.data_rule_views_to_titles_map
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "alert_suppression_rule_run_errors" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "ALERT_SUPPRESSION_RULE_RUN_ERRORS"
  comment  = "Alert Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/alert_suppression_rule_run_errors.sql", {
      data_alert_suppression_rule_runs = local.data_alert_suppression_rule_runs
      data_rule_views_to_titles_map    = local.data_rule_views_to_titles_map
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "violation_query_rule_run_errors" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "VIOLATION_QUERY_RULE_RUN_ERRORS"
  comment  = "Violation Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/violation_query_rule_run_errors.sql", {
      data_violation_query_rule_runs = local.data_violation_query_rule_runs
      data_rule_views_to_titles_map  = local.data_rule_views_to_titles_map
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "violation_suppression_rule_run_errors" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "VIOLATION_SUPPRESSION_RULE_RUN_ERRORS"
  comment  = "Violation Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/violation_suppression_rule_run_errors.sql", {
      data_violation_suppression_rule_runs = local.data_violation_suppression_rule_runs
      data_rule_views_to_titles_map        = local.data_rule_views_to_titles_map
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_view" "data_connector_run_errors" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "DATA_CONNECTOR_RUN_ERRORS"
  comment  = "Violation Query rule runs joined on errors."

  statement = templatefile(
    "${path.module}/views_sql/data_connector_run_errors.sql", {
      data_time_slices_before_t_without_time = local.data_time_slices_before_t_without_time
      ingestion_metadata_table               = local.results_ingestion_metadata_table
    }
  )
  or_replace = true

  depends_on = [
    module.snowalert_grants
  ]
}
