SELECT V:RUN_ID::VARCHAR AS run_id
    , V:START_TIME::TIMESTAMP AS start_time
    , V:END_TIME::TIMESTAMP AS end_time
    , V:ROW_COUNT.INSERTED::INTEGER AS num_alerts_created
    , V:ROW_COUNT.UPDATED::INTEGER AS num_alerts_updated
FROM results.run_metadata
WHERE V:RUN_TYPE='ALERT QUERY'
