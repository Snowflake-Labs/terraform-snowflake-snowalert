# 1. dispatcher
# CREATE OR REPLACE PROCEDURE results.alert_dispatcher()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-dispatcher.js'
# ;

# 2. deduplicator or merger
# CREATE OR REPLACE PROCEDURE results.alert_merge(deduplication_offset STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-merge.js'
# ;

# 3. processor
# CREATE OR REPLACE PROCEDURE results.alert_processor()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-processor.js'
# ;


# 4. Alert Query Runner
# CREATE OR REPLACE PROCEDURE results.alert_queries_runner(query_name STRING, from_time_sql STRING, to_time_sql STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-queries-runner.js'
# ;

# CREATE OR REPLACE PROCEDURE results.alert_queries_runner(query_name STRING, offset STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-queries-runner.js'
# ;

# CREATE OR REPLACE PROCEDURE results.alert_queries_runner(query_name STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-queries-runner.js'
# ;

# 5. Alert Scheduler
# CREATE OR REPLACE PROCEDURE results.alert_scheduler(warehouse STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-scheduler.js'
# ;

# 6. Alert Suppression Runner
# CREATE OR REPLACE PROCEDURE results.alert_suppressions_runner(queries_like STRING)
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-suppressions-runner.js'
# ;

# CREATE OR REPLACE PROCEDURE results.alert_suppressions_runner()
# RETURNS VARIANT
# LANGUAGE JAVASCRIPT
# EXECUTE AS CALLER
# USING TEMPLATE 'results-alert-suppressions-runner.js'
# ;


