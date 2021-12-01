# CREATE TABLE IF NOT EXISTS results.raw_alerts(
#   run_id STRING,
#   alert VARIANT,
#   alert_time TIMESTAMP_LTZ(9),
#   event_time TIMESTAMP_LTZ(9),
#   ticket STRING,
#   suppressed BOOLEAN,
#   suppression_rule STRING DEFAULT NULL,
#   counter INTEGER DEFAULT 1,
#   correlation_id STRING,
#   handled VARIANT
# );
resource "snowflake_table" "raw_alerts" {
  database        = snowflake_database.snowalert.name
  schema          = snowflake_schema.results.name
  name            = "RAW_ALERTS"
  change_tracking = true

  column {
    name = "RUN_ID"
    type = "VARCHAR(16777216)"
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
    type = "STRING"
  }

  column {
    name = "SUPPRESSED"
    type = "BOOLEAN"
  }

  column {
    name = "SUPPRESSION_RULE"
    type = "STRING"

    default {
      constant = 1
    }
  }

  column {
    name = "COUNTER"
    type = "INTEGER"

    default {
      constant = 1
    }
  }

  column {
    name = "CORRELATION_ID"
    type = "STRING"
  }

  column {
    name = "HANDLED"
    type = "VARIANT"
  }

  comment = "A raw alerts table."
}

# CREATE TABLE IF NOT EXISTS results.alerts(
#   alert_id STRING,
#   alert VARIANT,
#   alert_time TIMESTAMP_LTZ(9),
#   event_time TIMESTAMP_LTZ(9),
#   ticket STRING,
#   suppressed BOOLEAN,
#   suppression_rule STRING DEFAULT NULL,
#   counter INTEGER DEFAULT 1,
#   correlation_id STRING,
#   handled VARIANT
# );
resource "snowflake_table" "alerts" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "ALERTS"

  change_tracking = true

  column {
    name = "ALERT_ID"
    type = "STRING"
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
    type = "STRING"
  }

  column {
    name = "SUPPRESSED"
    type = "BOOLEAN"
  }

  column {
    name = "SUPPRESSION_RULE"
    type = "STRING"

    default {
      constant = 1
    }
  }

  column {
    name = "COUNTER"
    type = "INTEGER"

    default {
      constant = 1
    }
  }

  column {
    name = "CORRELATION_ID"
    type = "STRING"
  }

  column {
    name = "HANDLED"
    type = "VARIANT"
  }
}

# CREATE TABLE IF NOT EXISTS results.violations(
#   result VARIANT,
#   id STRING,
#   alert_time TIMESTAMP_LTZ(9),
#   ticket STRING,
#   suppressed BOOLEAN,
#   suppression_rule STRING DEFAULT NULL
# );
resource "snowflake_table" "violations" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "VIOLATIONS"

  column {
    name = "RESULT"
    type = "VARIANT"
  }

  column {
    name = "ID"
    type = "STRING"
  }

  column {
    name = "ALERT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "TICKET"
    type = "STRING"
  }

  column {
    name = "SUPPRESSED"
    type = "BOOLEAN"
  }

  column {
    name = "SUPPRESSION_RULE"
    type = "STRING"
  }
}

# CREATE TABLE IF NOT EXISTS results.query_metadata(
#   event_time TIMESTAMP_LTZ,
#   v VARIANT
# );
resource "snowflake_table" "query_metadata" {
  database = snowflake_database.snowalert.name
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

# CREATE TABLE IF NOT EXISTS results.run_metadata(
#   event_time TIMESTAMP_LTZ,
#   v VARIANT
# );
resource "snowflake_table" "run_metadata" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "RUN_METADATA"

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ"
  }

  column {
    name = "V"
    type = "VARIANT"
  }
}

# CREATE TABLE IF NOT EXISTS results.ingestion_metadata(
#   event_time TIMESTAMP_LTZ,
#   v VARIANT
# );
resource "snowflake_table" "ingestion_metadata" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name
  name     = "INGESTION_METADATA"

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ"
  }

  column {
    name = "V"
    type = "VARIANT"
  }
}
