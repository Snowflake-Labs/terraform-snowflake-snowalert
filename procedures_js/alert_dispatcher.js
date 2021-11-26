// args

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

// business logic

RUN_TABLE = 'results.handled_alerts'

HANDLE_ALERTS = `
  CREATE TEMP TABLE results.handled_alerts AS
  SELECT
    id alert_id,
    ARRAY_AGG(
      CASE
        WHEN value['type'] = 'ef-slack'
        THEN slack_handler(alert, value)
        WHEN value['type'] = 'ef-jira'
        THEN jira_handler(alert, value)
        WHEN value['type'] = 'ef-jira-comment'
        THEN jira_comment_handler(alert, value)
        WHEN value['type'] = 'ef-smtp'
        THEN smtp_handler(value)
        ELSE OBJECT_CONSTRUCT(
          'error', 'missing handler',
          'handler', value['type']
        )
      END
    ) handled
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
  ), LATERAL FLATTEN(input => handlers)
  WHERE value['type'] IN (
    'ef-slack',
    'ef-jira',
    'ef-jira-comment',
    'ef-smtp'
  )
  GROUP BY id
`

COUNT_HANDLED = `SELECT COUNT(*) n FROM $${RUN_TABLE}`

HANDLE_ALL = `
  MERGE INTO results.alerts d
  USING $${RUN_TABLE} s
  ON (d.alert_id = s.alert_id)
  WHEN MATCHED THEN UPDATE SET d.handled=s.handled
`

return {
    handle_alerts: exec(HANDLE_ALERTS),
    handled:
        exec(COUNT_HANDLED)[0]['N'] > 0
            ? exec(HANDLE_ALL)
            : { 'number of rows updated': 0, 'number of rows inserted': 0 },
    dropped: exec('DROP TABLE results.handled_alerts'),
}
