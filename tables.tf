resource "snowflake_table" "raw_alerts" {
  count    = var.create_tables ? 1 : 0
  provider = snowflake.alerting_role

  database        = local.snowalert_database_name
  schema          = local.results_schema
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

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  raw_alerts_table = var.create_tables ? snowflake_table.raw_alerts[0].name : "RAW_ALERTS"
}

resource "snowflake_table" "alerts" {
  count    = var.create_tables ? 1 : 0
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
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

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  alerts_table = var.create_tables ? snowflake_table.alerts[0].name : "ALERTS"
}

resource "snowflake_table" "violations" {
  count    = var.create_tables ? 1 : 0
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
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

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  violations_table = var.create_tables ? snowflake_table.violations[0].name : "VIOLATIONS"
}

resource "snowflake_table" "query_metadata" {
  count    = var.create_tables ? 1 : 0
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "QUERY_METADATA"

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "V"
    type = "VARIANT"
  }

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  query_metadata_table = var.create_tables ? snowflake_table.query_metadata[0].name : "QUERY_METADATA"
}

resource "snowflake_table" "run_metadata" {
  count    = var.create_tables ? 1 : 0
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "RUN_METADATA"

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "V"
    type = "VARIANT"
  }

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  run_metadata_table = var.create_tables ? snowflake_table.run_metadata[0].name : "RUN_METADATA"
}

resource "snowflake_table" "ingestion_metadata" {
  count    = var.create_tables ? 1 : 0
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "INGESTION_METADATA"

  column {
    name = "EVENT_TIME"
    type = "TIMESTAMP_LTZ(9)"
  }

  column {
    name = "V"
    type = "VARIANT"
  }

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  ingestion_metadata_table = var.create_tables ? snowflake_table.ingestion_metadata[0].name : "INGESTION_METADATA"
}
