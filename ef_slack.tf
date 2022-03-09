resource "snowflake_external_function" "slack_snowflake" {
  count    = contains(var.handlers, "slack") == true ? 1 : 0
  provider = snowflake.alerting_role

  name     = "SLACK_SNOWFLAKE"
  database = local.snowalert_database_name
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
    value = "/api/{1}"
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

resource "snowflake_function" "slack_snowflake_chat_post_message" {
  count    = contains(var.handlers, "slack") == true ? 1 : 0
  provider = snowflake.alerting_role

  name     = "SLACK_SNOWFLAKE_CHAT_POST_MESSAGE"
  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name

  arguments {
    name = "CHANNEL"
    type = "STRING"
  }

  arguments {
    name = "TEXT"
    type = "STRING"
  }

  return_type = "VARIANT"
  statement   = <<SQL
${local.snowalert_database_name}.${snowflake_schema.results.name}.${snowflake_external_function.slack_snowflake[0].name}(
  'post',
  'chat.postMessage',
  ${local.snowalert_database_name}.${snowflake_schema.data.name}.${snowflake_function.urlencode.name}(OBJECT_CONSTRUCT(
    'channel', channel::STRING,
    'text', text::STRING
  ))
)
SQL
}

resource "snowflake_function" "slack_handler" {
  count    = contains(var.handlers, "slack") == true ? 1 : 0
  provider = snowflake.alerting_role

  name     = "SLACK_HANDLER"
  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name

  arguments {
    name = "ALERT"
    type = "VARIANT"
  }

  arguments {
    name = "PAYLOAD"
    type = "VARIANT"
  }

  return_type = "VARIANT"
  statement   = <<SQL
${local.snowalert_database_name}.${snowflake_schema.results.name}.${snowflake_function.slack_snowflake_chat_post_message[0].name}(
  payload['channel'],
  payload['message']
)
SQL
}
