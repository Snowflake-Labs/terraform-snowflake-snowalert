SELECT start_time
    , run_id
    , title_field
    , title_from_comment
    , query_name
    , REGEXP_REPLACE(error:EXCEPTION_ONLY::STRING, '\\n', ' ') AS exception
FROM data.violation_query_rule_runs runs
LEFT JOIN data.rule_views_to_titles_map map
    ON runs.query_name=map.view_name
WHERE error IS NOT NULL
ORDER BY start_time DESC
