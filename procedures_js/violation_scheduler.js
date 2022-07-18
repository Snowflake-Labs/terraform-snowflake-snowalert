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
FROM ${snowalert_database_name}.INFORMATION_SCHEMA.VIEWS
WHERE table_schema='${rules_schema_name}'
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
  .filter((v) => ((find_tags(`$${v.qualified_view_name}`, 'VIOLATION_SCHEDULE')[0] !== null) || v.qualified_view_name.contains('VIOLATION_QUERY')   ))
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
    }))
    .map((v) => ({
      rule_name: v.rule_name,
      schedule:
        (find_tags(`$${v.qualified_view_name}`, 'VIOLATION_SCHEDULE')[0] || {})
          .TAG_VALUE || v.schedule,
    }))
    .map((v) => ({
      schedule: v.schedule,
      run_violation_query: unindent(`-- create violation query run task
        CREATE OR REPLACE TASK ${results_schema}.RUN_VIOLATION_QUERY_$${v.rule_name}
        WAREHOUSE=$${WAREHOUSE}
        SCHEDULE='$${v.schedule}'
        AS
        CALL ${results_violation_queries_runner}(
          '$${v.rule_name}',
        )
      `),
      resume_violation_query: unindent(`
        ALTER TASK ${results_schema}.RUN_VIOLATION_QUERY_$${v.rule_name} RESUME
      `),
      suspend_violation_query: unindent(`
        ALTER TASK IF EXISTS ${results_schema}.RUN_VIOLATION_QUERY_$${v.rule_name} SUSPEND
      `),
    }))
    .map((v) => ({
      run_violation: v.schedule == '-' ? '-' : exec(v.run_violation_query),
      resume_violation: v.schedule == '-' ? '-' : exec(v.resume_violation_query),
      suspend_violation: v.schedule == '-' ? exec(v.suspend_violation_query) : '-',
    })),
}
