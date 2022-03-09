resource "snowflake_table" "raw_alerts" {
  provider = snowflake.alerting_role

  database        = local.snowalert_database_name
  schema          = snowflake_schema.results.name
  name            = "RAW_ALERTS"
  change_tracking = true

  column {
    name = "RUN_ID"
    type = "VARCHAR(256)"
  }

  column {
    name = "ALERT"
    type = "VARIANT"
  }

  column {
    name = "ALERT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "TICKET"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "SUPPRESSED"
    type = "BOOLEAN"
  }

  column {
    name = "SUPPRESSION_RULE"
    type = "VARCHAR(16777216)"

    default {
      constant = 1
    }
  }

  column {
    name = "COUNTER"
    type = "NUMBER(38,0)"

    default {
      constant = 1
    }
  }

  column {
    name = "CORRELATION_ID"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "HANDLED"
    type = "VARIANT"
  }

  comment = "A raw alerts table."
}

resource "snowflake_table" "alerts" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name
  name     = "ALERTS"

  change_tracking = true

  column {
    name = "ALERT_ID"
    type = "VARCHAR(256)"
  }

  column {
    name = "ALERT"
    type = "VARIANT"
  }

  column {
    name = "ALERT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "TICKET"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "SUPPRESSED"
    type = "BOOLEAN"
  }

  column {
    name = "SUPPRESSION_RULE"
    type = "VARCHAR(16777216)"

    default {
      constant = 1
    }
  }

  column {
    name = "COUNTER"
    type = "NUMBER(38,0)"

    default {
      constant = 1
    }
  }

  column {
    name = "CORRELATION_ID"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "HANDLED"
    type = "VARIANT"
  }
}

resource "snowflake_table" "violations" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name
  name     = "VIOLATIONS"

  column {
    name = "RESULT"
    type = "VARIANT"
  }

  column {
    name = "ID"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "ALERT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "TICKET"
    type = "VARCHAR(16777216)"
  }

  column {
    name = "SUPPRESSED"
    type = "BOOLEAN"
  }

  column {
    name = "SUPPRESSION_RULE"
    type = "VARCHAR(16777216)"
  }
}

resource "snowflake_table" "query_metadata" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name
  name     = "QUERY_METADATA"

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "V"
    type = "VARIANT"
  }
}

resource "snowflake_table" "run_metadata" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name
  name     = "RUN_METADATA"

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "V"
    type = "VARIANT"
  }
}

resource "snowflake_table" "ingestion_metadata" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name
  name     = "INGESTION_METADATA"

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "V"
    type = "VARIANT"
  }
}
