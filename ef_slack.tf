resource "snowflake_external_function" "slack_snowflake" {
  count    = contains(var.handlers, "slack") == true ? 1 : 0
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "SLACK_SNOWFLAKE"

  # Function arguments
  arg {
    name = "METHOD"
    type = "VARCHAR"
  }

  arg {
    name = "PATH"
    type = "VARCHAR"
  }

  arg {
    name = "PARAMS"
    type = "VARCHAR"
  }

  # Function headers
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
  api_integration           = module.geff_snowalert[0].api_integration_name
  url_of_proxy_and_resource = "${module.geff_snowalert[0].api_gateway_invoke_url}${var.env}/https"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
slack_snowflake: (method, path, params) -> response
COMMENT

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  slack_snowflake_function = contains(var.handlers, "slack") == true ? join(".", [
    local.snowalert_database_name,
    local.results_schema,
    snowflake_external_function.slack_snowflake[0].name,
  ]) : null

  url_encode_function = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_function.urlencode.name,
  ])
}

resource "snowflake_function" "slack_snowflake_chat_post_message" {
  count    = contains(var.handlers, "slack") == true ? 1 : 0
  provider = snowflake.security_alerting_role

  name     = "SLACK_SNOWFLAKE_CHAT_POST_MESSAGE"
  database = local.snowalert_database_name
  schema   = local.results_schema

  # Function arguments
  arguments {
    name = "CHANNEL"
    type = "VARCHAR"
  }

  arguments {
    name = "TEXT"
    type = "VARCHAR"
  }

  return_type = "VARIANT"
  statement   = <<SQL
${local.slack_snowflake_function}(
  'post',
  'chat.postMessage',
  ${local.url_encode_function}(OBJECT_CONSTRUCT(
    'channel', channel::STRING,
    'text', text::STRING
  ))
)
SQL

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  slack_post_message_function = contains(var.handlers, "slack") == true ? join(".", [
    local.snowalert_database_name,
    local.results_schema,
    snowflake_function.slack_snowflake_chat_post_message[0].name,
  ]) : null
}

resource "snowflake_function" "slack_handler" {
  count    = contains(var.handlers, "slack") == true ? 1 : 0
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "SLACK_HANDLER"

  # Function arguments
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
${local.slack_post_message_function}(
  payload['channel'],
  payload['message']
)
SQL

  depends_on = [
    module.snowalert_grants
  ]
}
