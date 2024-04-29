// args

// library
function exec(sqlText, binds = []) {
  let rows = []
  const stmnt = snowflake.createStatement({ sqlText, binds })
  let result = null
  try {
    result = stmnt.execute()
  } catch (e) {
    return {
      error: {
        code: e.code,
        message: e.message,
        state: e.state,
      },
      sqlText: stmnt.getSqlText(),
      status: stmnt.getStatus(),
      queryId: stmnt.getQueryId(),
    }
  }
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
    rows.push(o)
  }
  return {
    rows,
    status: stmnt.getStatus(),
  }
}

// business logic
GET_HANDLERS = `
SELECT
  id alert_id,
  alert,
  alert_time,
  value['type'] handler_type,
  IFNULL(value['ttl_minutes'], 24*60) handler_ttl,
  value handler_payload,
  index handler_num,
  handled[index] handled_payload
FROM (
  SELECT
    id,
    IFF(
      IS_OBJECT(handlers),
      ARRAY_CONSTRUCT(handlers),
      handlers
    ) handler_payloads,
    handled,
    alert_time,
    OBJECT_CONSTRUCT(*) alert
  FROM ${data_alerts_view}
  WHERE suppressed = FALSE
  AND IS_ARRAY(handler_payloads)
), LATERAL FLATTEN(input => handler_payloads)
WHERE (
    handled_payload IS NULL
    OR IS_NULL_VALUE(handled_payload)
  )
  AND CONTAINS(handler_type, '-')
ORDER BY handler_ttl
LIMIT 100
`

return exec(GET_HANDLERS).rows.map((h) => {
  const handler_name =
    h.HANDLER_TYPE.replace(/^ef-/, '').replace(/-/g, '_') + '_handler'

  const alert = JSON.stringify(h.ALERT)
  const payload = JSON.stringify(h.HANDLER_PAYLOAD)
  const alert_id = h.ALERT_ID
  const alert_time = h.ALERT_TIME
  const handler_num = h.HANDLER_NUM
  const handler_ttl = h.HANLDER_TTL

  const result = exec(
    `UPDATE ${results_alerts_table}
    SET handled = ${results_array_set_function}(
      handled,
      $${handler_num},
      CASE
        WHEN ? < TIMEADD(MINUTES, -$${handler_ttl}, CURRENT_TIMESTAMP)
        THEN OBJECT_CONSTRUCT('success', FALSE, 'details', 'Alert TTL expired.')
        ELSE $${handler_name}(PARSE_JSON(?), PARSE_JSON(?))
      END
    )
    WHERE alert_id=?
    `,
    [alert_time, alert, payload, alert_id]
);


  return {
    alert_id,
    handler_name,
    result,
  }
})
