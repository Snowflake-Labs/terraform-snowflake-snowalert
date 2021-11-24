# CREATE OR REPLACE SECURE EXTERNAL FUNCTION snowalert.results.smtp_send(
#     recipient_email STRING,
#     subject STRING,
#     message_text STRING
# )
#   RETURNS VARIANT
#   RETURNS NULL ON NULL INPUT
#   VOLATILE
#   API_INTEGRATION={sa_api_integration}
#   HEADERS=(
#     'auth'              = {smtp_secrets_manager_arn}
#     'sender-email'      = {from_email_address}
#     'recipient-email'   = '{0}'
#     'subject'           = '{1}'
#     'text'              = '{2}'
#   )
# AS 'https://{aws_api_gateway_id}.execute-api.{aws_api_gateway_region}.amazonaws.com/prod/https'
# ;
resource "snowflake_external_function" "smtp_send" {
  name     = "smtp_send"
  database = snowalert.snowalert.name
  schema   = snowalert.results.name

  arg {
    name = "recipient_email"
    type = "STRING"
  }

  arg {
    name = "subject"
    type = "STRING"
  }

  arg {
    name = "message_text"
    type = "STRING"
  }

  header {
    name  = "auth"
    value = var.smtp_secrets_manager_arn
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
  api_integration           = local.geff_api_integration_name
  url_of_proxy_and_resource = "${local.geff_api_gateway_invoke_url}/${var.env}/smtp"

  return_type     = "VARIANT"
  return_behavior = "VOLATILE"

  comment = <<COMMENT
slack_snowflake: (method, path, params) -> response
COMMENT
}

# CREATE OR REPLACE SECURE FUNCTION snowalert.results.smtp_handler(alert VARIANT, payload VARIANT)
# RETURNS VARIANT
# AS $$
#   snowalert.results.smtp_send(payload['recipient'], payload['subject'], payload['message_text'])
# $$
# ;
resource "snowflake_function" "smtp_handler" {
  name     = "smtp_handler"
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

  language    = "SQL"
  return_type = "VARIANT"
  statement   = <<SQL
snowalert.results.smtp_send(payload['recipient'], payload['subject'], payload['message_text'])
SQL
}

# CREATE OR REPLACE SECURE FUNCTION snowalert.results.smtp_handler(payload VARIANT)
# RETURNS VARIANT
# AS $$
#   snowalert.results.smtp_handler(OBJECT_CONSTRUCT(), payload)
# $$
# ;
resource "snowflake_function" "smtp_handler" {
  name     = "smtp_handler"
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.results.name

  arguments {
    name = "payload"
    type = "VARIANT"
  }

  language    = "SQL"
  return_type = "VARIANT"
  statement   = <<SQL
snowalert.results.smtp_handler(OBJECT_CONSTRUCT(), payload)
SQL
}
