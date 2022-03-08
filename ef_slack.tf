# CREATE OR REPLACE SECURE EXTERNAL FUNCTION results.slack_snowflake(method STRING, path STRING, params STRING)
# RETURNS VARIANT
# RETURNS NULL ON NULL INPUT
# VOLATILE
# MAX_BATCH_ROWS=1
# COMMENT='slack_snowflake: (method, path, params) -> response'
# API_INTEGRATION={sa_api_integration}
# HEADERS=(
#   'base-url'='https://slack.com'
#   'method'='{0}'
#   'url'='/api/{1}'
#   'data'='{2}'
#   'auth'='{sa_jira_auth}'
# )
# AS 'https://{aws_api_gateway_id}.execute-api.{aws_api_gateway_region}.amazonaws.com/prod/https'
# ;
resource "snowflake_external_function" "slack_snowflake" {
  count    = contains(var.handlers, "slack") ? 1 : 0
  provider = snowflake.alerting_role

  name     = "SLACK_SNOWFLAKE"
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name

  arg {
    name = "METHOD"
    type = "STRING"
  }

  arg {
    name = "PATH"
    type = "STRING"
  }

  arg {
    name = "PARAMS"
    type = "STRING"
  }

  header {
    name  = "method"
    value = "{0}"
  }

  header {
    name  = "base-url"
    value = "https://slack.com"
  }

  header {
    name  = "url"
    value = "'/api/{1}'"
  }

  header {
    name  = "data"
    value = "{2}"
  }

  header {
    name  = "auth"
    value = var.slack_secrets_arn
  }

  return_null_allowed       = true
  max_batch_rows            = 1
  api_integration           = module.geff_snowalert.api_integration_name
  url_of_proxy_and_resource = "${module.geff_snowalert.api_gateway_invoke_url}/${var.env}/https"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
slack_snowflake: (method, path, params) -> response
COMMENT
}

# CREATE OR REPLACE FUNCTION results.slack_snowflake_chat_post_message(channel STRING, text STRING) RETURNS VARIANT
# AS $$
#   slack_snowflake(
#     'post',
#     'chat.postMessage',
#     URLENCODE(OBJECT_CONSTRUCT(
#       'channel', channel::STRING,
#       'text', text::STRING
#     ))
#   )
# $$
# ;
resource "snowflake_function" "slack_snowflake_chat_post_message" {
  count    = contains(var.handlers, "slack") ? 1 : 0
  provider = snowflake.alerting_role

  name     = "SLACK_SNOWFLAKE_CHAT_POST_MESSAGE"
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name

  arguments {
    name = "channel"
    type = "STRING"
  }

  arguments {
    name = "text"
    type = "STRING"
  }

  return_type = "VARIANT"
  statement   = <<SQL
${snowflake_database.snowalert.name}.${snowflake_schema.results.name}.${snowflake_external_function.slack_snowflake[0].name}.(
  'post',
  'chat.postMessage',
  URLENCODE(OBJECT_CONSTRUCT(
    'channel', channel::STRING,
    'text', text::STRING
  ))
)
SQL
}

# CREATE OR REPLACE FUNCTION results.slack_handler(alert VARIANT, payload VARIANT)
# RETURNS VARIANT
# AS $$
#   slack_snowflake_chat_post_message(
#     payload['channel'],
#     payload['message']
#   )
# $$
# ;
resource "snowflake_function" "slack_handler" {
  count    = contains(var.handlers, "slack") ? 1 : 0
  provider = snowflake.alerting_role

  name     = "SLACK_HANDLER"
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

  return_type = "VARIANT"
  statement   = <<SQL
${snowflake_database.snowalert.name}.${snowflake_schema.results.name}.${snowflake_function.slack_snowflake_chat_post_message[0].name}(
  payload['channel'],
  payload['message']
)
SQL
}
