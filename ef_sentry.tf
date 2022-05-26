resource "snowflake_external_function" "sentry_handler" {
  count    = contains(var.handlers, "sentry") == true ? 1 : 0
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "SENTRY_HANDLER"

  # Function arguments
  arg {
    name = "NAME"
    type = "STRING"
  }

  arg {
    name = "HISTORY_TYPE"
    type = "STRING"
  }

  arg {
    name = "ERROR"
    type = "STRING"
  }

  arg {
    name = "TS"
    type = "STRING"
  }

  arg {
    name = "HISTORY_URL"
    type = "STRING"
  }

  # Function headers
  header {
    name  = "name"
    value = "{0}"
  }

  header {
    name  = "history-type"
    value = "{1}"
  }

  header {
    name  = "error"
    value = "{2}"
  }

  header {
    name  = "ts"
    value = "{3}"
  }

  header {
    name  = "history-url"
    value = "{4}"
  }

  return_null_allowed       = true
  max_batch_rows            = 1
  api_integration           = module.geff_snowalert.api_integration_name
  url_of_proxy_and_resource = "${module.geff_snowalert.api_gateway_invoke_url}${var.env}/sentry_logger"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
sentry_handler: (name, history_type, error, ts, history_url) -> response
COMMENT
}
