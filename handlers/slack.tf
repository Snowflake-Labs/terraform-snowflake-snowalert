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

# CREATE OR REPLACE FUNCTION results.slack_handler(alert VARIANT, payload VARIANT)
# RETURNS VARIANT
# AS $$
#   slack_snowflake_chat_post_message(
#     payload['channel'],
#     payload['message']
#   )
# $$
# ;
