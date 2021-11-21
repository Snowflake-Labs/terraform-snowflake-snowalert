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

# CREATE OR REPLACE SECURE FUNCTION snowalert.results.smtp_handler(alert VARIANT, payload VARIANT)
# RETURNS VARIANT
# AS $$
#   snowalert.results.smtp_send(payload['recipient'], payload['subject'], payload['message_text'])
# $$
# ;

# CREATE OR REPLACE SECURE FUNCTION snowalert.results.smtp_handler(payload VARIANT)
# RETURNS VARIANT
# AS $$
#   snowalert.results.smtp_handler(OBJECT_CONSTRUCT(), payload)
# $$
# ;
