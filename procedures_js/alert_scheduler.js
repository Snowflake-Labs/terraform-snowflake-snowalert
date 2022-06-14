
// args
var WAREHOUSE

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

function unindent(s) {
  const min_indent = Math.min(
    ...[...s.matchAll('\n *')].map((x) => x[0].length)
  )
  return s.replace('\n' + ' '.repeat(min_indent), '\n')
}


// logic
FIND_VIEWS = String.raw`-- find views with schedules
SELECT CONCAT(
    TABLE_CATALOG,
    '.',
    TABLE_SCHEMA,
    '.',
    TABLE_OWNER
) as "qualified_view_name"
FROM SNOWALERT.INFORMATION_SCHEMA.VIEWS
`

function get_ddl(full_rule_name) {
    return exec(`SELECT GET_DDL('VIEW', '${full_rule_name}'`)
}

function find_tags(v, t) {
  return exec(unindent(`
    SELECT *
    FROM TABLE(
      INFORMATION_SCHEMA.TAG_REFERENCES(
        '$${v}',
        'TABLE'
      )
    )
    WHERE tag_name = '$${t}'
  `))
}

return {
  scheduled: exec(FIND_VIEWS)
    .filter(v => (
        v.view_definition.toLowerCase().includes('schedule') &&
        v.view_definition.toLowerCase().includes('lookback')
    ))
    .map(v => ({
        ...v,
        view_definition: get_ddl(v.qualified_view_name),
        schedule: v.view_definition.match(),
        lookback: v.view_definition.match()
    })
    .map((v) => ({
      rule_name: v.rule_name,
      schedule:
        (
          find_tags(
            `${rules_schema_name}.$${v.rule_name}`,
            'ALERT_SCHEDULE'
          )[0] || {}
        ).TAG_VALUE || v.schedule,
      lookback: v.lookback,
    }))
    // .filter(v => v.schedule != '-')
    .map((v) => ({
      schedule: v.schedule,
      run_alert_query: unindent(`-- create alert query run task
        CREATE OR REPLACE TASK ${results_schema}.RUN_ALERT_QUERY_$${v.rule_name}
        WAREHOUSE=$${WAREHOUSE}
        SCHEDULE='$${v.schedule}'
        AS
        CALL ${results_alert_queries_runner}(
          '$${v.rule_name}',
          '$${v.lookback}'
        )
      `),
      resume_alert_query: unindent(`
        ALTER TASK ${results_schema}.RUN_ALERT_QUERY_$${v.rule_name} RESUME
      `),
      suspend_alert_query: unindent(`
        ALTER TASK IF EXISTS ${results_schema}.RUN_ALERT_QUERY_$${v.rule_name} SUSPEND
      `),
    }))
    .map((v) => ({
      run_alert: v.schedule == '-' ? '-' : exec(v.run_alert_query),
      resume_alert: v.schedule == '-' ? '-' : exec(v.resume_alert_query),
      suspend_alert: v.schedule == '-' ? exec(v.suspend_alert_query) : '-',
    })),
}
