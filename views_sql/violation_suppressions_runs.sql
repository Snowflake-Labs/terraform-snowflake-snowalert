SELECT V:RUN_ID::VARCHAR AS run_id
  , V:START_TIME::TIMESTAMP AS start_time
  , V:END_TIME::TIMESTAMP AS end_time
  , V:ROW_COUNT.PASSED::INTEGER AS num_violations_passed
  , V:ROW_COUNT.SUPPRESSED::INTEGER AS num_violations_suppressed
FROM results.run_metadata
WHERE V:RUN_TYPE='VIOLATION SUPPRESSION'
