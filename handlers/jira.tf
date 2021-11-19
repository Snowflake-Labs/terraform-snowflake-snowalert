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


# CREATE OR REPLACE FUNCTION results.jira_handler(alert VARIANT, payload VARIANT)
# RETURNS VARIANT
# AS $$
#   snowalert_jira_api(
#     'POST',
#     '/rest/api/3/issue',
#     TO_JSON(OBJECT_CONSTRUCT(
#       'fields', OBJECT_CONSTRUCT(
#         'project', OBJECT_CONSTRUCT(
#           'key', COALESCE(payload['project'], '{sa_jira_project}')
#         ),
#         'issuetype', OBJECT_CONSTRUCT(
#           'name', COALESCE(payload['issue_type'], '{sa_jira_issue_type}')
#         ),
#         'summary', alert['TITLE']::STRING,
#         'description', OBJECT_CONSTRUCT(
#           'version', 1,
#           'type', 'doc',
#           'content', ARRAY_CONSTRUCT(
#             OBJECT_CONSTRUCT(
#               'type', 'paragraph',
#               'content', ARRAY_CONSTRUCT(
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Alert ID: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['ID']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Query ID: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['QUERY_ID']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Query Name: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['QUERY_NAME']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Environment: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['ENVIRONMENT']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Sources: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['SOURCES']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Categories: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', COALESCE(alert['CATEGORIES']::STRING, '-')
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Actor: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['ACTOR']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Object: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['OBJECT']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Action: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['ACTION']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Title: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['TITLE']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Event Time: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['EVENT_TIME']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Alert Time: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['ALERT_TIME']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Detector: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['DETECTOR']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Severity: ',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['SEVERITY']::STRING
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'hardBreak'
#                 ),
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Description:',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 )
#               )
#             ),
#             OBJECT_CONSTRUCT(
#               'type', 'blockquote',
#               'content', ARRAY_CONSTRUCT(
#                 OBJECT_CONSTRUCT(
#                   'type', 'paragraph',
#                   'content', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'text',
#                       'text', alert['DESCRIPTION']::STRING
#                     )
#                   )
#                 )
#               )
#             ),
#             OBJECT_CONSTRUCT(
#               'type', 'paragraph',
#               'content', ARRAY_CONSTRUCT(
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', 'Event Data:',
#                   'marks', ARRAY_CONSTRUCT(
#                     OBJECT_CONSTRUCT(
#                       'type', 'strong'
#                     )
#                   )
#                 )
#               )
#             ),
#             OBJECT_CONSTRUCT(
#               'type', 'codeBlock',
#               'attrs', OBJECT_CONSTRUCT(),
#               'content', ARRAY_CONSTRUCT(
#                 OBJECT_CONSTRUCT(
#                   'type', 'text',
#                   'text', alert['EVENT_DATA']::STRING
#                 )
#               )
#             )
#           )
#         )
#       )
#     )),
#     ''
# )
# $$
# ;
