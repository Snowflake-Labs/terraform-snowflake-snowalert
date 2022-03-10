resource "snowflake_external_function" "servicenow_create_incident" {
  count = contains(var.handlers, "servicenow") ? 1 : 0

  name     = "SERVICENOW_CREATE_INCIDENT"
  database = snowalert.snowalert.name
  schema   = snowalert.results.name

  arg {
    name = "payload"
    type = "STRING"
  }

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
  url_of_proxy_and_resource = "${module.geff_snowalert.api_gateway_invoke_url}/${var.env}/https"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
servicenow_create_incident: (payload) -> response
COMMENT
}
