# USE SCHEMA data;

# CREATE FUNCTION IF NOT EXISTS time_slices (n NUMBER, s TIMESTAMP_NTZ, e TIMESTAMP_NTZ)
# RETURNS TABLE ( slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ )
# AS $$
#   SELECT DATEADD(sec, DATEDIFF(sec, s, e) * ROW_NUMBER() OVER (ORDER BY SEQ4()) / n, s) AS slice_start
#        , DATEADD(sec, DATEDIFF(sec, s, e) * 1 / n, slice_start) AS slice_end
#   FROM TABLE(GENERATOR(ROWCOUNT => n))
# $$
# ;
resource "snowflake_function" "time_slices" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
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

  return_type     = "TABLE(slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ)"
  return_behavior = "IMMUTABLE"
  statement       = templatefile("${path.module}/functions_sql/time_slices.sql", {})
}

# CREATE FUNCTION IF NOT EXISTS time_slices_before_t (num_slices NUMBER, seconds_in_slice NUMBER, t TIMESTAMP_NTZ)
# RETURNS TABLE ( slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ )
# AS $$
# SELECT slice_start
#      , slice_end
# FROM TABLE(
#   time_slices(
#     num_slices,
#     DATEADD(sec, -seconds_in_slice * num_slices, t),
#     t
#   )
# )
# $$
# ;
resource "snowflake_function" "time_slices_before_t_with_t" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
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

  return_type = "TABLE(slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ)"
  statement = templatefile(
    "${path.module}/functions_sql/time_slices_before_t_with_t.sql", {
      time_slices_function = join(".", [
        snowflake_database.snowalert.name,
        snowflake_schema.data.name,
        snowflake_function.time_slices.name,
      ])
    }
  )
}

# CREATE FUNCTION IF NOT EXISTS time_slices_before_t (num_slices NUMBER, seconds_in_slice NUMBER)
# RETURNS TABLE ( slice_start TIMESTAMP, slice_end TIMESTAMP )
# AS $$
# SELECT slice_start
#      , slice_end
# FROM TABLE(
#   time_slices(
#     num_slices,
#     DATEADD(sec, -seconds_in_slice * num_slices, CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP)::TIMESTAMP),
#     CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP)::TIMESTAMP
#   )
# )
# $$
# ;
resource "snowflake_function" "time_slices_before_t_without_t" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
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

  return_type = "TABLE(slice_start TIMESTAMP, slice_end TIMESTAMP)"
  statement = templatefile(
    "${path.module}/functions_sql/time_slices_before_t_without_t.sql", {
      time_slices_function = join(".", [
        snowflake_database.snowalert.name,
        snowflake_schema.data.name,
        snowflake_function.time_slices.name,
      ])
    }
  )
}

# CREATE FUNCTION IF NOT EXISTS object_assign (o1 VARIANT, o2 VARIANT)
# RETURNS VARIANT
# LANGUAGE javascript
# AS $$
#   return Object.assign(O1, O2)
# $$
# ;
resource "snowflake_function" "object_assign" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
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

# CREATE OR REPLACE FUNCTION urlencode("obj" VARIANT) RETURNS STRING
# LANGUAGE javascript
# AS $$
# var ret = []
# for (var p in obj)
# if (obj.hasOwnProperty(p)) {
#   var v = obj[p]
#   v = v instanceof Date ? v.toISOString() : v
#   ret.push(encodeURIComponent(p) + "=" + encodeURIComponent(v))
# }
# return ret.join("&")
# $$
# ;
resource "snowflake_function" "urlencode" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
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

# CREATE OR REPLACE FUNCTION rules.has_no_violations(qid VARCHAR)
# RETURNS BOOLEAN
# AS '
# (
#   SELECT COUNT(*) AS c FROM data.violations
#   WHERE created_time > DATEADD(day, -1, CURRENT_TIMESTAMP())
#     AND query_id = qid
# ) = 0
# ';
resource "snowflake_function" "has_no_violations" {
  provider = snowflake.alerting_role

  database = snowflake_database.snowalert.name
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
  FROM ${snowflake_database.snowalert.name}.${snowflake_schema.data.name}.${snowflake_view.violations.name}
  WHERE created_time > DATEADD(day, -1, CURRENT_TIMESTAMP())
    AND query_id = qid
) = 0
SQL
}
