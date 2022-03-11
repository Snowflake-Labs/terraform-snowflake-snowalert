resource "snowflake_external_function" "servicenow_create_incident" {
  count    = contains(var.handlers, "servicenow") == true ? 1 : 0
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "SERVICENOW_CREATE_INCIDENT"

  # Function arguments
  arg {
    name = "PAYLOAD"
    type = "STRING"
  }

  # Function headers
  header {
    name  = "method"
    value = "post"
  }

  header {
    name  = "url"
    value = var.servicenow_api_url
  }

  header {
    name  = "json"
    value = "{0}"
  }

  header {
    name  = "auth"
    value = var.servicenow_secrets_arn
  }

  return_null_allowed       = true
  max_batch_rows            = 1
  api_integration           = module.geff_snowalert.api_integration_name
  url_of_proxy_and_resource = "${module.geff_snowalert.api_gateway_invoke_url}${var.env}/https"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
servicenow_create_incident: (payload) -> response
COMMENT
}

locals {
  servicenow_create_incident = contains(var.handlers, "servicenow") == true ? join(".", [
    local.snowalert_database_name,
    local.results_schema,
    snowflake_external_function.servicenow_create_incident[0].name,
  ]) : null
}
