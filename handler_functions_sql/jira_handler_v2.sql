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
                'description', '|| Field || Value ||\r\n'
                    || '||Alert ID|| ' || alert['ID']::STRING || ' ||\r\n'
                    || '||Query ID|| ' || alert['QUERY_ID']::STRING || ' ||\r\n'
                    || '||Query Name|| ' || alert['QUERY_NAME']::STRING || ' ||\r\n'
                    || '||Environment|| ' || alert['ENVIRONMENT']::STRING || ' ||\r\n'
                    || '||Sources|| ' || alert['SOURCES']::STRING || ' ||\r\n'
                    || '||Categories|| ' || COALESCE(alert['CATEGORIES']::STRING, '-') || ' ||\r\n'
                    || '||Actor|| ' || alert['ACTOR']::STRING || ' ||\r\n'
                    || '||Object|| ' || alert['OBJECT']::STRING || ' ||\r\n'
                    || '||Action|| ' || alert['ACTION']::STRING || ' ||\r\n'
                    || '||Title|| ' || alert['TITLE']::STRING || ' ||\r\n'
                    || '||Event Time|| ' || alert['EVENT_TIME']::STRING || ' ||\r\n'
                    || '||Alert Time|| ' || alert['ALERT_TIME']::STRING || ' ||\r\n'
                    || '||Detector|| ' || alert['DETECTOR']::STRING || ' ||\r\n'
                    || '||Severity|| ' || alert['SEVERITY']::STRING || ' ||\r\n'
                    || '||Description|| ' || alert['DESCRIPTION']::STRING || ' ||\r\n'
                    || '||Event Data|| ' || alert['EVENT_DATA']::STRING || ' ||\r\n'

            )
        )
    ),
    ''
)
