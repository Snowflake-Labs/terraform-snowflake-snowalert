resource "snowflake_function" "time_slices" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.data.name
  name     = "TIME_SLICES"

  arguments {
    name = "N"
    type = "NUMBER"
  }

  arguments {
    name = "S"
    type = "TIMESTAMP_NTZ"
  }

  arguments {
    name = "E"
    type = "TIMESTAMP_NTZ"
  }

  return_type     = "TABLE (slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ)"
  return_behavior = "IMMUTABLE"
  statement       = templatefile("${path.module}/functions_sql/time_slices.sql", {})
}

resource "snowflake_function" "time_slices_before_t_with_t" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.data.name
  name     = "TIME_SLICES_BEFORE_T"

  arguments {
    name = "NUM_SLICES"
    type = "NUMBER"
  }

  arguments {
    name = "SECONDS_IN_SLICE"
    type = "NUMBER"
  }

  arguments {
    name = "T"
    type = "TIMESTAMP_NTZ"
  }

  return_type = "TABLE (slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ)"
  statement = templatefile(
    "${path.module}/functions_sql/time_slices_before_t_with_t.sql", {
      time_slices_function = join(".", [
        local.snowalert_database_name,
        snowflake_schema.data.name,
        snowflake_function.time_slices.name,
      ])
    }
  )
}

resource "snowflake_function" "time_slices_before_t_without_t" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.data.name
  name     = "TIME_SLICES_BEFORE_T"

  arguments {
    name = "NUM_SLICES"
    type = "NUMBER"
  }

  arguments {
    name = "SECONDS_IN_SLICE"
    type = "NUMBER"
  }

  return_type = "TABLE (slice_start TIMESTAMP, slice_end TIMESTAMP)"
  statement = templatefile(
    "${path.module}/functions_sql/time_slices_before_t_without_t.sql", {
      time_slices_function = join(".", [
        local.snowalert_database_name,
        snowflake_schema.data.name,
        snowflake_function.time_slices.name,
      ])
    }
  )
}

resource "snowflake_function" "object_assign" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.data.name
  name     = "OBJECT_ASSIGN"

  arguments {
    name = "o1"
    type = "VARIANT"
  }

  arguments {
    name = "o2"
    type = "VARIANT"
  }

  language    = "javascript"
  return_type = "VARIANT"
  statement   = <<javascript
return Object.assign(O1, O2)
javascript
}

resource "snowflake_function" "urlencode" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.data.name
  name     = "URLENCODE"

  arguments {
    name = "OBJ"
    type = "VARIANT"
  }

  language    = "javascript"
  return_type = "VARCHAR"
  statement   = <<javascript
var ret = []
for (var p in OBJ)
if (OBJ.hasOwnProperty(p)) {
  var v = OBJ[p]
  v = v instanceof Date ? v.toISOString() : v
  ret.push(encodeURIComponent(p) + "=" + encodeURIComponent(v))
}
return ret.join("&")
javascript
}

resource "snowflake_function" "has_no_violations" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = snowflake_schema.rules.name
  name     = "HAS_NO_VIOLATIONS"

  arguments {
    name = "qid"
    type = "VARCHAR"
  }

  return_type = "BOOLEAN"
  statement   = <<SQL
(
  SELECT COUNT(*) AS c
  FROM ${local.snowalert_database_name}.${snowflake_schema.data.name}.${snowflake_view.violations.name}
  WHERE created_time > DATEADD(day, -1, CURRENT_TIMESTAMP())
    AND query_id = qid
) = 0
SQL
}
