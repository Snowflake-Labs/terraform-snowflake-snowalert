// args
var QUERY_NAME, FROM_TIME_SQL, TO_TIME_SQL, DEDUPLICATION_OFFSET

DEDUPLICATION_OFFSET = DEDUPLICATION_OFFSET || '90 minutes'
FROM_TIME_SQL =
  FROM_TIME_SQL || `CURRENT_TIMESTAMP - INTERVAL '$${DEDUPLICATION_OFFSET}'`
TO_TIME_SQL = TO_TIME_SQL || 'CURRENT_TIMESTAMP'
// library
function exec(sqlText, binds = []) {
  let retval = []
  const stmnt = snowflake.createStatement({ sqlText, binds })
  const result = stmnt.execute()
  const columnCount = stmnt.getColumnCount()
  const columnNames = []
  for (let i = 1; i < columnCount + 1; i++) {
    columnNames.push(stmnt.getColumnName(i))
  }

  while (result.next()) {
    let o = {}
    for (let c of columnNames) {
      o[c] = result.getColumnValue(c)
    }
    retval.push(o)
  }
  return retval
}

function fillArray(value, len) {
  const arr = []
  for (var i = 0; i < len; i++) {
    arr.push(value)
  }
  return arr
}

const MERGE_ALERTS =
  `
MERGE INTO ${results_alerts_table} AS alerts
USING (

  SELECT ANY_VALUE(alert) AS alert
    , SUM(counter) AS counter
    , MIN(alert_time) AS alert_time
    , MIN(event_time) AS event_time

  FROM ${results_raw_alerts_merge_stream}

  GROUP BY
    alert:OBJECT,
    alert:DESCRIPTION,
    alert:EVENT_DATA,
    alert:TITLE

) AS new_alerts

ON (
  alerts.alert:EVENT_TIME > ` +
  FROM_TIME_SQL +
  `
  AND alerts.alert:OBJECT = new_alerts.alert:OBJECT
  AND alerts.alert:DESCRIPTION = new_alerts.alert:DESCRIPTION
  AND alerts.alert:EVENT_DATA = new_alerts.alert:EVENT_DATA
  AND alerts.alert:TITLE = new_alerts.alert:TITLE
)

WHEN MATCHED
  THEN UPDATE
  SET counter = alerts.counter + new_alerts.counter

WHEN NOT MATCHED
  THEN INSERT (
    alert,
    alert_id,
    counter,
    alert_time,
    event_time
  )
  VALUES (
    new_alerts.alert,
    new_alerts.alert['ALERT_ID'],
    new_alerts.counter,
    new_alerts.alert_time,
    new_alerts.event_time
  )
;
;`

return {
  run_id: RUN_ID,
  create_alerts_result: exec(MERGE_ALERTS)[0],
}
