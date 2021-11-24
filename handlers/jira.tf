# CREATE OR REPLACE SECURE EXTERNAL FUNCTION results.snowalert_jira_api(method STRING, path STRING, body STRING, querystring STRING)
# RETURNS VARIANT
# RETURNS NULL ON NULL INPUT
# VOLATILE
# MAX_BATCH_ROWS=1
# COMMENT='jira_api: (method, path, body) -> api_response
# https://developer.atlassian.com/cloud/jira/platform/rest/v3/'
# API_INTEGRATION={sa_api_integration}
# HEADERS=(
#   'method'='{0}'
#   'base-url'='https://snowflakecomputing.atlassian.net'
#   'url'='{1}'
#   'data'='{2}'
#   'params'='{3}'
#   'headers'='content-type=application%2Fjson&accept=application%2Fjson'
#   'auth'='{sa_jira_auth}'
# )
# AS 'https://{aws_api_gateway_id}.execute-api.{aws_api_gateway_region}.amazonaws.com/prod/https'
# ;
resource "snowflake_external_function" "snowalert_jira_api" {
  name     = "snowalert_jira_api"
  database = snowalert.snowalert.name
  schema   = snowalert.results.name

  arg {
    name = "method"
    type = "STRING"
  }

  arg {
    name = "path"
    type = "STRING"
  }

  arg {
    name = "body"
    type = "STRING"
  }

  arg {
    name = "querystring"
    type = "STRING"
  }

  header {
    name  = "method"
    value = "{0}"
  }

  header {
    name  = "base-url"
    value = "https://snowflakecomputing.atlassian.net"
  }

  header {
    name  = "url"
    value = "{1}"
  }

  header {
    name  = "params"
    value = "{3}"
  }

  header {
    name  = "data"
    value = "{2}"
  }

  header {
    name  = "headers"
    value = "content-type=application%2Fjson&accept=application%2Fjson"
  }

  header {
    name  = "auth"
    value = var.sa_jira_auth_secrets_arn
  }

  return_null_allowed       = true
  return_type               = "VARIANT"
  return_behavior           = "VOLATILE"
  api_integration           = local.geff_api_integration_name
  url_of_proxy_and_resource = "${local.geff_api_gateway_invoke_url}/${var.env}/https"

  comment = <<COMMENT
jira_api: (method, path, body) -> api_response
https://developer.atlassian.com/cloud/jira/platform/rest/v3/
COMMENT
}

# CREATE OR REPLACE FUNCTION results.jira_handler(alert VARIANT, payload VARIANT)
# RETURNS VARIANT
# AS $$
#   get from jira_handler.sql
# $$
# ;
resource "snowflake_function" "jira_handler" {
  name     = "jira_handler"
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name

  arguments {
    name = "alert"
    type = "VARIANT"
  }

  arguments {
    name = "payload"
    type = "VARIANT"
  }

  language        = "SQL"
  return_type     = "VARIANT"
  return_behavior = "IMMUTABLE"
  statement       = templatefile("${path.module}/handlers/user_defined_functions_sql/jira_handler.sql", {})
}
