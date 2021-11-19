# -- 1. Runs the alert queries merge
# CREATE OR REPLACE TASK results.alerts_merge
#   WAREHOUSE=snowalert_warehouse
#   SCHEDULE='USING CRON * * * * * UTC'
# AS
# CALL results.alerts_merge('30m')
# ;

# -- 2. Runs the alerts supressions merge
# CREATE OR REPLACE TASK results.suppressions_merge 
#   WAREHOUSE=snowalert_warehouse
#   AFTER results.alerts_merge
# AS
# CALL results.alert_suppressions_runner()
# ;
