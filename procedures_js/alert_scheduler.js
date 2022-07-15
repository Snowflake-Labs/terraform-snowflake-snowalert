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
SELECT table_name AS "rule_name",
  CONCAT(
    TABLE_CATALOG,
    '.',
    TABLE_SCHEMA,
    '.',
    TABLE_NAME
  ) as "qualified_view_name"
FROM INFORMATION_SCHEMA.VIEWS
WHERE table_schema='${rules_schema_name}'
  AND table_name NOT LIKE '%_VIOLATION_QUERY' 
`

function get_ddl(full_rule_name) {
  return exec(
    `SELECT GET_DDL('VIEW', '$${full_rule_name}') AS "view_definition"`
  )[0].view_definition
}

function find_tags(v, t) {
  return exec(
    unindent(`
    SELECT *
    FROM TABLE(
      INFORMATION_SCHEMA.TAG_REFERENCES(
        '$${v}',
        'TABLE'
      )
    )
    WHERE tag_name = '$${t}'
  `)
  )
}

function get_first_regex_group(regex, s) {
  let match = s.match(regex)
  if (match !== undefined && match !== null) {
    return match[1]
  }

  return null
}

return {
  scheduled: exec(FIND_VIEWS)
    .map((v) => ({
      ...v,
      view_definition: get_ddl(v.qualified_view_name),
    }))
    .map((v) => ({
      ...v,
      schedule:
        get_first_regex_group(
          /'([^']*)'\s+as\s+schedule\b/i,
          v.view_definition
        ) || '-',
      lookback:
        get_first_regex_group(
          /'([^']*)'\s+as\s+lookback\b/i,
          v.view_definition
        ) || '1d',
    }))
    .map((v) => ({
      rule_name: v.rule_name,
      schedule:
        (find_tags(`$${v.qualified_view_name}`, 'ALERT_SCHEDULE')[0] || {})
          .TAG_VALUE || v.schedule,
      lookback: v.lookback || '',
    }))
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
