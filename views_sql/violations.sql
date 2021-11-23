SELECT id
    , alert_time AS created_time
    , ticket
    , suppressed
    , suppression_rule
    , result['ENVIRONMENT']::VARIANT  AS environment
    , result['OBJECT']::VARCHAR       AS object
    , result['TITLE']::VARCHAR        AS title
    , result['ALERT_TIME']::TIMESTAMP AS violation_time
    , result['DESCRIPTION']::VARCHAR  AS description
    , result['EVENT_DATA']::VARIANT   AS event_data
    , result['DETECTOR']::VARCHAR     AS detector
    , result['SEVERITY']::VARCHAR     AS severity
    , result['QUERY_ID']::VARCHAR     AS query_id
    , result['QUERY_NAME']::VARCHAR   AS query_name
    , result['OWNER']::VARCHAR        AS owner
FROM results.violations
