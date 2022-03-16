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
    value['type'] handler_type,
    value handler_payload,
    index handler_num
  FROM (
    SELECT
      id,
      IFF(
        IS_OBJECT(handlers),
        ARRAY_CONSTRUCT(handlers),
        handlers
      ) handlers,
      OBJECT_CONSTRUCT(*) alert
    FROM data.alerts
    WHERE handled IS NULL
      AND ticket IS NULL
      AND suppressed = FALSE
      AND (
        IS_OBJECT(handlers)
        OR IS_ARRAY(handlers)
      )
      LIMIT 10
  ),
  LATERAL FLATTEN(input => handlers)
`

return exec(GET_HANDLERS).rows.map((h) => {
    const handler_name =
        h.HANDLER_TYPE.replace(/^ef-/, '').replace(/-/g, '_') + '_handler'
    const alert = JSON.stringify(h.ALERT)
    const payload = JSON.stringify(h.HANDLER_PAYLOAD)
    const alert_id = h.ALERT_ID

    const result = exec(
        `UPDATE results.alerts
        SET handled = results.array_set(
          handled,
          $${handler_num},
          $${handler_name}(PARSE_JSON(?), PARSE_JSON(?))
        )
        WHERE alert_id=?`,
        [alert, payload, alert_id]
    )

    return {
        alert_id,
        handler_name,
        result,
    }
})
