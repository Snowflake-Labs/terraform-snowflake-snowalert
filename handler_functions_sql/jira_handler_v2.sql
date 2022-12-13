${jira_api_function}(
    'POST',
    '/rest/api/2/issue',
    TO_JSON(
        OBJECT_CONSTRUCT(
            'fields', OBJECT_CONSTRUCT(
                'labels', ARRAY_CONSTRUCT('SnowAlert'),
                'assignee', OBJECT_CONSTRUCT(
                    'name',  COALESCE(payload['assignee_email_address'], NULL)
                ),
                'project', OBJECT_CONSTRUCT(
                    'key', COALESCE(payload['project'], '${default_jira_project}')
                ),
                'issuetype', OBJECT_CONSTRUCT(
                    'name', COALESCE(payload['issue_type'], '${default_jira_issue_type}')
                ),
                'summary', alert['TITLE']::STRING,
                'description', '```' || ${json_beautify_function}(
                    TO_JSON(
                        OBJECT_CONSTRUCT(
                            'Alert ID', alert['ID']::STRING,
                            'Query ID', alert['QUERY_ID']::STRING,
                            'Query Name', alert['QUERY_NAME']::STRING,
                            'Environment', alert['ENVIRONMENT']::STRING,
                            'Sources', alert['SOURCES']::STRING,
                            'Categories', COALESCE(alert['CATEGORIES']::STRING, '-'),
                            'Actor', alert['ACTOR']::STRING,
                            'Object', alert['OBJECT']::STRING,
                            'Action', alert['ACTION']::STRING,
                            'Title', alert['TITLE']::STRING,
                            'Event Time', alert['EVENT_TIME']::STRING,
                            'Alert Time', alert['ALERT_TIME']::STRING,
                            'Detector', alert['DETECTOR']::STRING,
                            'Severity', alert['SEVERITY']::STRING,
                            'Description', alert['DESCRIPTION']::STRING,
                            'Event Data', alert['EVENT_DATA']::STRING
                        )
                    ),
                    4
                ) || '```'
            )
        )
    ),
    ''
)
