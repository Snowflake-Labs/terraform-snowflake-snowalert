// args
var QUERY_NAME, FROM_TIME_SQL, TO_TIME_SQL, OFFSET

OFFSET = OFFSET || '90 minutes'
FROM_TIME_SQL = FROM_TIME_SQL || `CURRENT_TIMESTAMP - INTERVAL '$${OFFSET}'`
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

function ifColumnExists(column_name) {
  column = exec(
    `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = '${rules_schema_name}'
       AND TABLE_NAME = '$${QUERY_NAME}'
       AND COLUMN_NAME = '$${column_name}'`
  )

  if (column == column_name) {
    return `,'CORRELATION_PERIOD', IFNULL(CORRELATION_PERIOD::VARIANT, PARSE_JSON('null')),`
  } else {
    return ''
  }
}

const RUN_ID = Math.random().toString(36).substring(2).toUpperCase()
const RAW_ALERTS_TABLE = `${results_raw_alerts_table}`

const CREATE_ALERTS_SQL = `INSERT INTO $${RAW_ALERTS_TABLE} (
  run_id,
  alert,
  alert_time,
  event_time,
  counter
)
SELECT '$${RUN_ID}' run_id
  , OBJECT_CONSTRUCT(
      'ALERT_ID', UUID_STRING(),
      'QUERY_NAME', '$${QUERY_NAME}',
      'QUERY_ID', IFNULL(QUERY_ID::VARIANT, PARSE_JSON('null')),
      'ENVIRONMENT', IFNULL(ENVIRONMENT::VARIANT, PARSE_JSON('null')),
      'SOURCES', IFNULL(SOURCES::VARIANT, PARSE_JSON('null')),
      'ACTOR', IFNULL(ACTOR::VARIANT, PARSE_JSON('null')),
      'OBJECT', IFNULL(OBJECT::VARIANT, PARSE_JSON('null')),
      'ACTION', IFNULL(ACTION::VARIANT, PARSE_JSON('null')),
      'TITLE', IFNULL(TITLE::VARIANT, PARSE_JSON('null')),
      'EVENT_TIME', IFNULL(EVENT_TIME::VARIANT, PARSE_JSON('null')),
      'ALERT_TIME', IFNULL(ALERT_TIME::VARIANT, PARSE_JSON('null')),
      'DESCRIPTION', IFNULL(DESCRIPTION::VARIANT, PARSE_JSON('null')),
      'DETECTOR', IFNULL(DETECTOR::VARIANT, PARSE_JSON('null')),
      'EVENT_DATA', IFNULL(EVENT_DATA::VARIANT, PARSE_JSON('null')),
      'SEVERITY', IFNULL(SEVERITY::VARIANT, PARSE_JSON('null')),
      'HANDLERS', IFNULL(OBJECT_CONSTRUCT(*):HANDLERS::VARIANT, PARSE_JSON('null'))
      $${ifColumnExists('CORRELATION_PERIOD')}
  ) AS alert
  , alert_time
  , event_time
  , 1 AS counter
FROM ${rules_schema}.$${QUERY_NAME}
WHERE event_time BETWEEN $${FROM_TIME_SQL} AND $${TO_TIME_SQL}
;`

return {
  run_id: RUN_ID,
  create_alerts_result: exec(CREATE_ALERTS_SQL)[0],
}
