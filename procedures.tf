resource "snowflake_procedure" "alert_dispatcher" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_DISPATCHER"
  language = "JAVASCRIPT"

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement = templatefile(
    "${path.module}/procedures_js/alert_dispatcher.js", {
      results_alerts_table = join(".", [
        local.snowalert_database_name,
        local.results_schema,
        local.alerts_table,
      ])
      results_array_set_function = join(".", [
        local.snowalert_database_name,
        local.results_schema,
        snowflake_function.array_set.name,
      ])
      data_alerts_view = join(".", [
        local.snowalert_database_name,
        local.data_schema,
        snowflake_view.alerts.name,
      ])
    }
  )

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "alert_merge" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_MERGE"
  language = "JAVASCRIPT"

  arguments {
    name = "DEDUPLICATION_OFFSET"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"

  statement = templatefile("${path.module}/procedures_js/alert_merge.js", {
    results_alerts_table = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      local.alerts_table,
    ])
    results_raw_alerts_merge_stream = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      snowflake_stream.raw_alerts_merge_stream.name,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "alert_processor" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_PROCESSOR"
  language = "JAVASCRIPT"

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement = templatefile("${path.module}/procedures_js/alert_processor.js", {
    results_alerts_table = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      local.alerts_table,
    ])
    data_alerts_view = join(".", [
      local.snowalert_database_name,
      local.data_schema,
      snowflake_view.alerts.name,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "alert_queries_runner_with_time" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_QUERIES_RUNNER"
  language = "JAVASCRIPT"

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
  statement = templatefile("${path.module}/procedures_js/alert_queries_runner.js", {
    results_raw_alerts_table = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      local.raw_alerts_table,
    ])
    rules_schema = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "alert_queries_runner_without_time" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_QUERIES_RUNNER"
  language = "JAVASCRIPT"

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
  statement = templatefile("${path.module}/procedures_js/alert_queries_runner.js", {
    results_raw_alerts_table = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      local.raw_alerts_table,
    ])
    rules_schema = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "alert_queries_runner" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_QUERIES_RUNNER"
  language = "JAVASCRIPT"

  arguments {
    name = "query_name"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement = templatefile("${path.module}/procedures_js/alert_queries_runner.js", {
    results_raw_alerts_table = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      local.raw_alerts_table,
    ])
    rules_schema = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "alert_scheduler" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_SCHEDULER"
  language = "JAVASCRIPT"

  arguments {
    name = "warehouse"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement = templatefile("${path.module}/procedures_js/alert_scheduler.js", {
    rules_schema_name = local.rules_schema
    rules_schema = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
    ])
    results_schema = join(".", [
      local.snowalert_database_name,
      local.results_schema,
    ])
    results_raw_alerts_table = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
      local.raw_alerts_table,
    ])
    results_alert_queries_runner = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      snowflake_procedure.alert_queries_runner_without_time.name,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "alert_suppressions_runner" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_SUPPRESSIONS_RUNNER"
  language = "JAVASCRIPT"

  arguments {
    name = "queries_like"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement = templatefile("${path.module}/procedures_js/alert_suppressions_runner.js", {
    rules_schema = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
    ])
    results_schema = join(".", [
      local.snowalert_database_name,
      local.results_schema,
    ])
    results_alerts_table = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      local.alerts_table,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "alert_suppressions_runner_without_queries_like" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ALERT_SUPPRESSIONS_RUNNER"
  language = "JAVASCRIPT"

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement = templatefile("${path.module}/procedures_js/alert_suppressions_runner.js", {
    rules_schema = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
    ])
    results_schema = join(".", [
      local.snowalert_database_name,
      local.results_schema,
    ])
    results_alerts_table = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      local.alerts_table,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_procedure" "violation_scheduler" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "VIOLATION_SCHEDULER"

  arguments {
    name = "warehouse"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement = templatefile("${path.module}/procedures_js/violation_scheduler.js", {
    rules_schema_name = local.rules_schema
    snowalert_database_name = local.snowalert_database_name
    rules_schema = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
    ])
    results_schema = join(".", [
      local.snowalert_database_name,
      local.results_schema,
    ])
    results_violations_table = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
      local.violations_table,
    ])
    results_violation_queries_runner = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      snowflake_procedure.violation_queries_runner.name,
    ])
  })
}

resource "snowflake_procedure" "violation_queries_runner" {
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "VIOLATION_QUERIES_RUNNER"
  language = "JAVASCRIPT"

  return_type = "VARIANT"
  execute_as  = "CALLER"
  statement = templatefile("${path.module}/procedures_js/violation_queries_runner.js", {
    rules_schema = join(".", [
      local.snowalert_database_name,
      local.rules_schema,
    ])
    results_schema = join(".", [
      local.snowalert_database_name,
      local.results_schema,
    ])
    results_alerts_table = join(".", [
      local.snowalert_database_name,
      local.results_schema,
      local.alerts_table,
    ])
  })

  depends_on = [
    module.snowalert_grants
  ]
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
