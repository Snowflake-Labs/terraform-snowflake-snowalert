SELECT alert['ALERT_ID']::VARCHAR AS id
    , correlation_id
    , alert_time
    , event_time
    , ticket
    , suppressed
    , suppression_rule
    , handled
    , alert['QUERY_NAME']::VARCHAR   AS query_name
    , alert['QUERY_ID']::VARCHAR     AS query_id
    , alert['ENVIRONMENT']::VARIANT  AS environment
    , alert['SOURCES']::VARIANT      AS sources
    , alert['ACTOR']::VARCHAR        AS actor
    , alert['OBJECT']::VARCHAR       AS object
    , alert['ACTION']::VARCHAR       AS action
    , alert['TITLE']::VARCHAR        AS title
    , alert['DESCRIPTION']::VARCHAR  AS description
    , alert['DETECTOR']::VARCHAR     AS detector
    , alert['EVENT_DATA']::VARIANT   AS event_data
    , alert['SEVERITY']::VARCHAR     AS severity
    , alert['HANDLERS']::VARIANT     AS handlers
FROM ${results_alerts}
