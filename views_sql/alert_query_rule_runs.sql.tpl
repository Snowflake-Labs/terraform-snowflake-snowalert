SELECT V:RUN_ID::VARCHAR AS run_id
  , V:QUERY_NAME::VARCHAR AS query_name
  , V:START_TIME::TIMESTAMP AS start_time
  , V:END_TIME::TIMESTAMP AS end_time
  , V:ERROR AS error
  , V:ROW_COUNT.INSERTED::INTEGER AS num_alerts_created
  , V:ROW_COUNT.UPDATED::INTEGER AS num_alerts_updated
FROM results.query_metadata
WHERE V:QUERY_NAME ILIKE '%_ALERT_QUERY'
