//args
var CORRELATION_PERIOD_MINUTES

CORRELATION_PERIOD_MINUTES = CORRELATION_PERIOD_MINUTES || '60 minutes'

var alert_correlation_result_array = []

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
WHERE alert:ACTOR = :1
  AND (alert:OBJECT::STRING = :2 OR alert:ACTION::STRING = :3)
  AND correlation_id IS NOT NULL
  AND NOT IS_NULL_VALUE(alert:ACTOR)
  AND suppressed = FALSE
  AND event_time >  
      CASE REGEXP_SUBSTR(LOWER(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}')), '[a-z]')
        WHEN 's' THEN DATEADD(seconds, - TO_NUMBER(REGEXP_SUBSTR(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}'), '\\\\d+')), :4)
        WHEN 'm' THEN DATEADD(minutes, - TO_NUMBER(REGEXP_SUBSTR(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}'), '\\\\d+')), :4)
        WHEN 'h' THEN DATEADD(hours, - TO_NUMBER(REGEXP_SUBSTR(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}'), '\\\\d+')), :4)
        WHEN 'd' THEN DATEADD(days, - TO_NUMBER(REGEXP_SUBSTR(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}'), '\\\\d+')), :4)
      END
ORDER BY event_time DESC
LIMIT 1
`

function find_related_correlation_id(alert) {
  if (
    'ACTOR' in alert == false ||
    'OBJECT' in alert == false ||
    'ACTION' in alert == false ||
    'EVENT_TIME' in alert == false
  ) {
    return null
  }

  actor = alert['ACTOR']
  object = alert['OBJECT']
  action = alert['ACTION']
  time = alert['EVENT_TIME']

  if (object instanceof Array) {
    o = object.join('","')
    object = `["$${o}"]`
  }
  if (action instanceof Array) {
    o = action.join('","')
    action = `["$${o}"]`
  }

  match = exec(GET_CORRELATED_ALERT, [actor, object, action, time])[0] || {}

  return match['CORRELATION_ID'] || null
}

GET_ALERTS_WITHOUT_CORRELATION_ID = `
SELECT *
FROM ${results_alerts_table}
WHERE correlation_id IS NULL
  AND suppressed = FALSE
  AND alert_time > DATEADD(hour, -2, CURRENT_TIMESTAMP())
`

UPDATE_ALERT_CORRELATION_ID = `
UPDATE ${results_alerts_table}
SET correlation_id = COALESCE(:1, UUID_STRING())
WHERE alert:EVENT_TIME >
      CASE REGEXP_SUBSTR(LOWER(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}')), '[a-z]')
        WHEN 's' THEN DATEADD(seconds, - TO_NUMBER(REGEXP_SUBSTR(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}'), '\\\\d+')), :2)
        WHEN 'm' THEN DATEADD(minutes, - TO_NUMBER(REGEXP_SUBSTR(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}'), '\\\\d+')), :2)
        WHEN 'h' THEN DATEADD(hours, - TO_NUMBER(REGEXP_SUBSTR(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}'), '\\\\d+')), :2)
        WHEN 'd' THEN DATEADD(days, - TO_NUMBER(REGEXP_SUBSTR(COALESCE(alert:CORRELATION_PERIOD, '$${CORRELATION_PERIOD_MINUTES}'), '\\\\d+')), :2)
      END
  AND alert:ALERT_ID = :3
`

for (const row of exec(GET_ALERTS_WITHOUT_CORRELATION_ID)) {
  alert_body = row['ALERT']
  correlation_id = find_related_correlation_id(alert_body)
  event_time = String(alert_body['EVENT_TIME'])
  alert_id = alert_body['ALERT_ID']

  alert_correlation_result_array.push({
    alert_id: alert_id,
    alert_correlation_result: exec(UPDATE_ALERT_CORRELATION_ID, [
      correlation_id,
      event_time,
      alert_id,
    ]),
  })
}

return alert_correlation_result_array
