${database}.${schema}.SNOWALERT_JIRA_API(
    'POST',
    '/rest/api/3/issue',
    TO_JSON(
        OBJECT_CONSTRUCT(
            'fields', OBJECT_CONSTRUCT(
                'labels', ARRAY_CONSTRUCT('SnowAlert'),
                'assignee', OBJECT_CONSTRUCT(
                    'accountId',  COALESCE(payload['assignee'], NULL)
                ),
                'project', OBJECT_CONSTRUCT(
                    'key', COALESCE(payload['project'], '${default_jira_project}')
                ),
                'issuetype', OBJECT_CONSTRUCT(
                    'name', COALESCE(payload['issue_type'], '${default_jira_issue_type}')
                ),
                'summary', alert['TITLE']::STRING,
                'description', OBJECT_CONSTRUCT(
                    'version', 1,
                    'type', 'doc',
                    'content', ARRAY_CONSTRUCT(
                        OBJECT_CONSTRUCT(
                            'type', 'paragraph',
                            'content', ARRAY_CONSTRUCT(
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Alert ID: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['ID']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Query ID: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['QUERY_ID']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Query Name: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['QUERY_NAME']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Environment: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['ENVIRONMENT']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Sources: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['SOURCES']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Categories: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', COALESCE(alert['CATEGORIES']::STRING, '-')
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Actor: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['ACTOR']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Object: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['OBJECT']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Action: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['ACTION']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Title: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['TITLE']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Event Time: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['EVENT_TIME']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Alert Time: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['ALERT_TIME']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Detector: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['DETECTOR']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Severity: ',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['SEVERITY']::STRING
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'hardBreak'
                                ),
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Description:',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                )
                            )
                        ),
                        OBJECT_CONSTRUCT(
                            'type', 'blockquote',
                            'content', ARRAY_CONSTRUCT(
                                OBJECT_CONSTRUCT(
                                    'type', 'paragraph',
                                    'content', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'text',
                                            'text', alert['DESCRIPTION']::STRING
                                        )
                                    )
                                )
                            )
                        ),
                        OBJECT_CONSTRUCT(
                            'type', 'paragraph',
                            'content', ARRAY_CONSTRUCT(
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', 'Event Data:',
                                    'marks', ARRAY_CONSTRUCT(
                                        OBJECT_CONSTRUCT(
                                            'type', 'strong'
                                        )
                                    )
                                )
                            )
                        ),
                        OBJECT_CONSTRUCT(
                            'type', 'codeBlock',
                            'attrs', OBJECT_CONSTRUCT(),
                            'content', ARRAY_CONSTRUCT(
                                OBJECT_CONSTRUCT(
                                    'type', 'text',
                                    'text', alert['EVENT_DATA']::STRING
                                )
                            )
                        )
                    )
                )
            )
        )
    ),
    ''
)
