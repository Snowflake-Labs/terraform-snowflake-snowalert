# CREATE TABLE IF NOT EXISTS results.raw_alerts(
#   run_id STRING,
#   alert VARIANT,
#   alert_time TIMESTAMP_LTZ(9),
#   event_time TIMESTAMP_LTZ(9),
#   ticket STRING,
#   suppressed BOOLEAN,
#   suppression_rule STRING DEFAULT NULL,
#   counter INTEGER DEFAULT 1,
#   correlation_id STRING,
#   handled VARIANT
# );


# CREATE TABLE IF NOT EXISTS results.alerts(
#   alert_id STRING,
#   alert VARIANT,
#   alert_time TIMESTAMP_LTZ(9),
#   event_time TIMESTAMP_LTZ(9),
#   ticket STRING,
#   suppressed BOOLEAN,
#   suppression_rule STRING DEFAULT NULL,
#   counter INTEGER DEFAULT 1,
#   correlation_id STRING,
#   handled VARIANT
# );

# CREATE TABLE IF NOT EXISTS results.violations(
#   result VARIANT,
#   id STRING,
#   alert_time TIMESTAMP_LTZ(9),
#   ticket STRING,
#   suppressed BOOLEAN,
#   suppression_rule STRING DEFAULT NULL
# );

# CREATE TABLE IF NOT EXISTS results.query_metadata(
#   event_time TIMESTAMP_LTZ,
#   v VARIANT
# );
# CREATE TABLE IF NOT EXISTS results.run_metadata(
#   event_time TIMESTAMP_LTZ,
#   v VARIANT
# );
# CREATE TABLE IF NOT EXISTS results.ingestion_metadata(
#   event_time TIMESTAMP_LTZ,
#   v VARIANT
# );
