resource "snowflake_external_function" "smtp_send" {
  count    = contains(var.handlers, "smtp") == true ? 1 : 0
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "SMTP_SEND"

  # Function arguments
  arg {
    name = "RECIPIENT_EMAIL"
    type = "STRING"
  }

  arg {
    name = "SUBJECT"
    type = "STRING"
  }

  arg {
    name = "MESSAGE_TEXT"
    type = "STRING"
  }

  # Function headers
  header {
    name  = "auth"
    value = var.smtp_secrets_arn
  }

  header {
    name  = "sender-email"
    value = var.smtp_driver_from_email_address
  }

  header {
    name  = "recipient-email"
    value = "{0}"
  }

  header {
    name  = "subject"
    value = "{1}"
  }

  header {
    name  = "text"
    value = "{2}"
  }

  return_null_allowed       = true
  max_batch_rows            = 1
  api_integration           = module.geff_snowalert.api_integration_name
  url_of_proxy_and_resource = "${module.geff_snowalert.api_gateway_invoke_url}${var.env}/https"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
slack_snowflake: (method, path, params) -> response
COMMENT
}

locals {
  smtp_send_function = contains(var.handlers, "smtp") == true ? join(".", [
    local.snowalert_database_name,
    local.results_schema,
    snowflake_external_function.smtp_send[0].name,
  ]) : null
}

resource "snowflake_function" "smtp_handler" {
  count    = contains(var.handlers, "smtp") == true ? 1 : 0
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "SMTP_HANDLER"

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
${local.smtp_send_function}(
  payload['recipient'],
  payload['subject'],
  payload['message_text']
)
SQL
}

locals {
  smtp_handler_function = contains(var.handlers, "smtp") == true ? join(".", [
    local.snowalert_database_name,
    local.results_schema,
    snowflake_function.smtp_handler[0].name,
  ]) : null
}

resource "snowflake_function" "smtp_handler_1_arg" {
  count    = contains(var.handlers, "smtp") == true ? 1 : 0
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "SMTP_HANDLER"

  # Function arguments
  arguments {
    name = "PAYLOAD"
    type = "VARIANT"
  }

  return_type = "VARIANT"
  statement   = <<SQL
${local.smtp_handler_function}(
  OBJECT_CONSTRUCT(),
  payload
)
SQL
}
