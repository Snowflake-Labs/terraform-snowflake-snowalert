resource "snowflake_function" "time_slices_without_tz" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
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
  statement       = templatefile("${path.module}/functions_sql/time_slices_without_tz.sql", {})

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function" "time_slices_with_tz" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "TIME_SLICES"

  arguments {
    name = "N"
    type = "NUMBER"
  }

  arguments {
    name = "S"
    type = "TIMESTAMP_LTZ"
  }

  arguments {
    name = "E"
    type = "TIMESTAMP_LTZ"
  }

  return_type     = "TABLE (slice_start TIMESTAMP_LTZ, slice_end TIMESTAMP_LTZ)"
  return_behavior = "IMMUTABLE"
  statement       = templatefile("${path.module}/functions_sql/time_slices_with_tz.sql", {})

  depends_on = [
    module.snowalert_grants
  ]
}

locals {
  data_time_slices_without_tz_function = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_function.time_slices_without_tz.name,
  ])

  data_time_slices_with_tz_function = join(".", [
    local.snowalert_database_name,
    local.data_schema,
    snowflake_function.time_slices_with_tz.name,
  ])
}

resource "snowflake_function" "time_slices_before_t_without_tz" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
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
    "${path.module}/functions_sql/time_slices_before_t_without_tz.sql", {
      data_time_slices_without_tz_function = local.data_time_slices_without_tz_function
    }
  )

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function" "time_slices_before_t_with_tz" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
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
    type = "TIMESTAMP_LTZ"
  }

  return_type = "TABLE (slice_start TIMESTAMP_LTZ, slice_end TIMESTAMP_LTZ)"
  statement = templatefile(
    "${path.module}/functions_sql/time_slices_before_t_with_tz.sql", {
      data_time_slices_with_tz_function = local.data_time_slices_with_tz_function
    }
  )

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function" "time_slices_before_t_without_time" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "TIME_SLICES_BEFORE_T"

  arguments {
    name = "NUM_SLICES"
    type = "NUMBER"
  }

  arguments {
    name = "SECONDS_IN_SLICE"
    type = "NUMBER"
  }

  return_type = "TABLE (slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ)"
  statement = templatefile(
    "${path.module}/functions_sql/time_slices_before_t_without_time.sql", {
      data_time_slices_without_tz_function = local.data_time_slices_without_tz_function
    }
  )

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function" "object_assign" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
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

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function" "urlencode" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
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

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function_grant" "urlencode" {
  provider = snowflake.alerting_role

  database_name = local.snowalert_database_name
  schema_name   = local.data_schema
  function_name = "URLENCODE"

  argument_data_types = ["VARIANT"]
  privilege           = "USAGE"
  roles = [
    var.ingest_role,
    var.modeling_role,
  ]

  depends_on = [
    snowflake_function.urlencode,
  ]
}

resource "snowflake_function" "array_set" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "ARRAY_SET"

  arguments {
    name = "XS"
    type = "VARIANT"
  }

  arguments {
    name = "I"
    type = "VARIANT"
  }

  arguments {
    name = "X"
    type = "VARIANT"
  }

  return_type = "VARIANT"
  language    = "javascript"
  statement   = <<javascript
  XS = XS || []
  XS[I] = X
  // map null and undefined value to proper JSON null
  return Array.from(XS).map(_ => _ == null ? null : _)
javascript

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function" "json_beautify_with_indent" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "JSON_BEAUTIFY"

  arguments {
    name = "STR"
    type = "VARCHAR"
  }

  arguments {
    name = "INDENT"
    type = "FLOAT"
  }

  return_type = "VARCHAR"
  language    = "javascript"
  statement   = <<javascript
try {
  return JSON.stringify(JSON.parse(STR), null, INDENT);
} catch (err) {
  return STR
}
javascript

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function" "json_beautify_without_indent" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "JSON_BEAUTIFY"

  arguments {
    name = "STR"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "javascript"
  statement = <<javascript
${join(".", [
  local.snowalert_database_name,
  local.data_schema,
  snowflake_function.json_beautify_with_indent.name,
])}.(STR, 2)
javascript

depends_on = [
  module.snowalert_grants
]
}

resource "snowflake_function" "convert_time_period_to_seconds" {
  provider = snowflake.alerting_role

  database = local.snowalert_database_name
  schema   = local.data_schema
  name     = "CONVERT_TIME_PERIOD_TO_SECONDS"

  arguments {
      name = "PERIOD"
      type = "VARCHAR"
  }

  return_type = "FLOAT"
  language    = "javascript"
  statement   = <<javascript
var value = parseInt(PERIOD.match(/\d+/)[0]);
var unit = PERIOD.toLowerCase().match(/[a-z]/)[0];
return value * (
  unit == 'm' ? 60 :
  unit == 'h' ? 60*60 :
  unit == 'd' ? 60*60*24 :
  1
)
javascript

  depends_on = [
    module.snowalert_grants
  ]
}
