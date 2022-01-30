# CREATE OR REPLACE EXTERNAL FUNCTION results.servicenow_create_incident(payload STRING)
#     RETURNS VARIANT
#     RETURNS NULL ON NULL INPUT
#     VOLATILE
#     API_INTEGRATION=integration
#     HEADERS=(
#     'method'='post'
#     'url'={service_now_api_url}
#     'json'='{0}'
#     'auth'='arn:aws:secretsmanager:us-west-2:12332435:secret:dev/servicenow/api_secrets'
#     )
#     AS 'https://ASDFASDF.execute-api.us-west-2.amazonaws.com/prod/https'
# ;
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
  api_integration           = local.geff_api_integration_name
  url_of_proxy_and_resource = "${local.geff_api_gateway_invoke_url}/${var.env}/https"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
servicenow_create_incident: (payload) -> response
COMMENT
}
