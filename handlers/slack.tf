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
  name     = "slack_snowflake"
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
    name = "params"
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
    value = var.sa_jira_auth_secrets_arn
  }

  return_null_allowed       = true
  max_batch_rows            = 1
  api_integration           = local.geff_api_integration_name
  url_of_proxy_and_resource = "${local.geff_api_gateway_invoke_url}/${var.env}/https"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
slack_snowflake: (method, path, params) -> response
COMMENT
}

# CREATE OR REPLACE FUNCTION results.urlencode("obj" VARIANT) RETURNS STRING
# LANGUAGE JAVASCRIPT
# AS $$
# var ret = [];
# for (var p in obj)
# if (obj.hasOwnProperty(p)) {
#   var v = obj[p];
#   v = v instanceof Date ? v.toISOString() : v;
#   ret.push(encodeURIComponent(p) + "=" + encodeURIComponent(v));
# }
# return ret.join("&");
# $$
# ;
resource "snowflake_function" "urlencode" {
  name     = "urlencode"
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name

  arguments {
    name = "obj"
    type = "VARIANT"
  }

  language    = "JAVASCRIPT"
  return_type = "STRING"
  statement   = <<JAVASCRIPT
var ret = [];
for (var p in obj)
if (obj.hasOwnProperty(p)) {
  var v = obj[p];
  v = v instanceof Date ? v.toISOString() : v;
  ret.push(encodeURIComponent(p) + "=" + encodeURIComponent(v));
}
return ret.join("&");
JAVASCRIPT
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
  name     = "slack_snowflake_chat_post_message"
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

  language    = "SQL"
  return_type = "VARIANT"
  statement   = <<SQL
slack_snowflake(
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
resource "snowflake_function" "slack_snowflake_chat_post_message" {
  name     = "slack_snowflake_chat_post_message"
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

  language    = "SQL"
  return_type = "VARIANT"
  statement   = <<SQL
slack_snowflake_chat_post_message(
  payload['channel'],
  payload['message']
)
SQL
}
