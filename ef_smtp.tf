# resource "snowflake_external_function" "smtp_send" {
#   count = contains(var.handlers, "smtp") ? 1 : 0

#   name     = "SMTP_SEND"
#   database = snowalert.snowalert.name
#   schema   = snowalert.results.name

#   arg {
#     name = "RECIPIENT_EMAIL"
#     type = "STRING"
#   }

#   arg {
#     name = "SUBJECT"
#     type = "STRING"
#   }

#   arg {
#     name = "MESSAGE_TEXT"
#     type = "STRING"
#   }

#   header {
#     name  = "auth"
#     value = var.smtp_secrets_arn
#   }

#   header {
#     name  = "sender-email"
#     value = var.smtp_driver_from_email_address
#   }

#   header {
#     name  = "recipient-email"
#     value = "{0}"
#   }

#   header {
#     name  = "subject"
#     value = "{1}"
#   }

#   header {
#     name  = "text"
#     value = "{2}"
#   }

#   return_null_allowed       = true
#   max_batch_rows            = 1
#   api_integration           = local.geff_api_integration_name
#   url_of_proxy_and_resource = "${local.geff_api_gateway_invoke_url}/${var.env}/smtp"

#   return_type     = "VARIANT"
#   return_behavior = "VOLATILE"

#   comment = <<COMMENT
# slack_snowflake: (method, path, params) -> response
# COMMENT
# }

# resource "snowflake_function" "smtp_handler" {
#   name     = "SMTP_HANDLER"
#   database = local.snowalert_database_name
#   schema   = local.results_schema_name

#   arguments {
#     name = "ALERT"
#     type = "VARIANT"
#   }

#   arguments {
#     name = "PAYLOAD"
#     type = "VARIANT"
#   }

#   return_type = "VARIANT"
#   statement   = <<SQL
# snowalert.results.smtp_send(payload['recipient'], payload['subject'], payload['message_text'])
# SQL
# }

# resource "snowflake_function" "smtp_handler" {
#   name     = "SMTP_HANDLER"
#   database = local.snowalert_database_name
#   schema   = local.results_schema_name

#   arguments {
#     name = "PAYLOAD"
#     type = "VARIANT"
#   }

#   return_type = "VARIANT"
#   statement   = <<SQL
# snowalert.results.smtp_handler(OBJECT_CONSTRUCT(), payload)
# SQL
# }
