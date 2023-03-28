//args
var CORRELATION_PERIOD_MINUTES

CORRELATION_PERIOD_MINUTES = CORRELATION_PERIOD_MINUTES || -60

var alert_correlation_result = []

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

GET_CORRELATED_ALERT = `
SELECT correlation_id
FROM ${results_alerts_table}
WHERE alert:ACTOR = ?
  AND (alert:OBJECT::STRING = ? OR alert:ACTION::STRING = ?)
  AND correlation_id IS NOT NULL
  AND NOT IS_NULL_VALUE(alert:ACTOR)
  AND suppressed = FALSE
  AND event_time > DATEADD(minutes, $${CORRELATION_PERIOD_MINUTES}, ?)
ORDER BY event_time DESC
LIMIT 1
`

function generate_uuid() {
  GENERATE_UUID = `SELECT UUID_STRING()`
  return exec(GENERATE_UUID)[0][['UUID_STRING()']]
}

function find_related_correlation_id(alert) {
  if (
    'ACTOR' in alert == false ||
    'OBJECT' in alert == false ||
    'ACTION' in alert == false ||
    'EVENT_TIME' in alert == false
  ) {
    return generate_uuid()
  }

  actor = alert['ACTOR']
  object = alert['OBJECT']
  action = alert['ACTION']
  time = alert['EVENT_TIME']

  if (object instanceof Array) {
    o = object.join('","')
    object = `'["$${o}"]'`
  }
  if (action instanceof Array) {
    o = action.join('","')
    action = `'["$${o}"]'`
  }

  match = exec(GET_CORRELATED_ALERT, [actor, object, action, time]) || {}

  return match['CORRELATION_ID'] || generate_uuid()
}

GET_ALERTS_WITHOUT_CORREALTION_ID = `
SELECT *
FROM ${results_alerts_table}
WHERE correlation_id IS NULL
  AND suppressed = FALSE
  AND alert_time > DATEADD(hour, -2, CURRENT_TIMESTAMP())
`

UPDATE_ALERT_CORRELATION_ID = `
UPDATE ${results_alerts_table}
SET correlation_id = COALESCE(?, UUID_STRING())
WHERE alert:EVENT_TIME > DATEADD(minutes, $${CORRELATION_PERIOD_MINUTES}, ?)
  AND alert:ALERT_ID = ?
`

for (const row of exec(GET_ALERTS_WITHOUT_CORREALTION_ID)) {
  alert_body = row['ALERT']
  correlation_id = find_related_correlation_id(alert_body)
  event_time = String(alert_body['EVENT_TIME'])
  alert_id = alert_body['ALERT_ID']

  alert_correlation_result.push(
    exec(UPDATE_ALERT_CORRELATION_ID, [correlation_id, event_time, alert_id])
  )
}

return { alert_correlation_result }
