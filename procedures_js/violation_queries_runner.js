// args
var QUERY_NAME

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

function unindent(s) {
    const min_indent = Math.min(
        ...[...s.matchAll('\n *')].map((x) => x[0].length)
    )
    return s.replace('\n' + ' '.repeat(min_indent), '\n')
}

const RUN_ID = Math.random().toString(36).substring(2).toUpperCase()

const INSERT_VIOLATIONS = `INSERT INTO results.violations (
  alert_time,
  id,
  result
)
SELECT CURRENT_TIMESTAMP()
  , MD5(TO_JSON(
      IFNULL(
        OBJECT_CONSTRUCT(*):IDENTITY,
        OBJECT_CONSTRUCT(
          'ENVIRONMENT', IFNULL(OBJECT_CONSTRUCT(*):ENVIRONMENT, PARSE_JSON('null')), 
          'OBJECT', IFNULL(OBJECT_CONSTRUCT(*):OBJECT, PARSE_JSON('null')),
          'OWNER', IFNULL(OBJECT_CONSTRUCT(*):OWNER, PARSE_JSON('null')),
          'TITLE', IFNULL(OBJECT_CONSTRUCT(*):TITLE, PARSE_JSON('null')),
          'DESCRIPTION', IFNULL(OBJECT_CONSTRUCT(*):DESCRIPTION, PARSE_JSON('null')),
          'EVENT_DATA', IFNULL(OBJECT_CONSTRUCT(*):EVENT_DATA, PARSE_JSON('null')),
          'DETECTOR', IFNULL(OBJECT_CONSTRUCT(*):DETECTOR, PARSE_JSON('null')),
          'SEVERITY', IFNULL(OBJECT_CONSTRUCT(*):SEVERITY, PARSE_JSON('null')),
          'QUERY_ID', IFNULL(OBJECT_CONSTRUCT(*):QUERY_ID, PARSE_JSON('null')),
          'QUERY_NAME', '$${QUERY_NAME}'
        )
      )
    ))
  , data.object_assign(
      OBJECT_CONSTRUCT(*),
      OBJECT_CONSTRUCT('QUERY_NAME', '$${QUERY_NAME}')
    )
FROM rules.$${QUERY_NAME}
;`

return {
    run_id: RUN_ID,
    insert_violations: exec(INSERT_VIOLATIONS)[0],
}
