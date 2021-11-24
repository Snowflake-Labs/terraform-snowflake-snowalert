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
  name     = "time_slices"
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name

  arguments {
    name = "n"
    type = "NUMBER"
  }

  arguments {
    name = "s"
    type = "TIMESTAMP_NTZ"
  }

  arguments {
    name = "e"
    type = "TIMESTAMP_NTZ"
  }

  language        = "SQL"
  return_type     = "TABLE (slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ)" # TODO: I don't think this type is supported
  return_behavior = "IMMUTABLE"
  statement       = <<SQL
SELECT DATEADD(sec, DATEDIFF(sec, s, e) * ROW_NUMBER() OVER (ORDER BY SEQ4()) / n, s) AS slice_start
      , DATEADD(sec, DATEDIFF(sec, s, e) * 1 / n, slice_start) AS slice_end
FROM TABLE(GENERATOR(ROWCOUNT => n))
SQL
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
resource "snowflake_function" "time_slices_before_t" {
  name     = "time_slices_before_t"
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name

  arguments {
    name = "num_slices"
    type = "NUMBER"
  }

  arguments {
    name = "seconds_in_slice"
    type = "NUMBER"
  }

  arguments {
    name = "t"
    type = "TIMESTAMP_NTZ"
  }

  language    = "SQL"
  return_type = "TABLE (slice_start TIMESTAMP_NTZ, slice_end TIMESTAMP_NTZ)" # TODO: I don't think this type is supported
  statement   = <<SQL
SELECT slice_start
     , slice_end
FROM TABLE(
  time_slices(
    num_slices,
    DATEADD(sec, -seconds_in_slice * num_slices, t),
    t
  )
)
SQL
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
resource "snowflake_function" "time_slices_before_t" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "time_slices_before_t"

  arguments {
    name = "num_slices"
    type = "NUMBER"
  }

  arguments {
    name = "seconds_in_slice"
    type = "NUMBER"
  }

  language    = "SQL"
  return_type = "TABLE (slice_start TIMESTAMP, slice_end TIMESTAMP)"
  statement   = <<SQL
SELECT slice_start
     , slice_end
FROM TABLE(
  time_slices(
    num_slices,
    DATEADD(sec, -seconds_in_slice * num_slices, CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP)::TIMESTAMP),
    CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP)::TIMESTAMP
  )
)
SQL
}

# CREATE FUNCTION IF NOT EXISTS object_assign (o1 VARIANT, o2 VARIANT)
# RETURNS VARIANT
# LANGUAGE javascript
# AS $$
#   return Object.assign(O1, O2)
# $$
# ;
resource "snowflake_function" "object_assign" {
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "object_assign"

  arguments {
    name = "o1"
    type = "VARIANT"
  }

  arguments {
    name = "o2"
    type = "VARIANT"
  }

  language    = "JAVASCRIPT"
  return_type = "VARIANT"
  statement   = <<JAVASCRIPT
return Object.assign(O1, O2)
JAVASCRIPT
}

# CREATE OR REPLACE FUNCTION urlencode("obj" VARIANT) RETURNS STRING
# LANGUAGE JAVASCRIPT
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
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.data.name
  name     = "urlencode"

  arguments {
    name = "obj"
    type = "VARIANT"
  }

  language    = "JAVASCRIPT"
  return_type = "STRING"
  statement   = <<JAVASCRIPT
var ret = []
for (var p in obj)
if (obj.hasOwnProperty(p)) {
  var v = obj[p]
  v = v instanceof Date ? v.toISOString() : v
  ret.push(encodeURIComponent(p) + "=" + encodeURIComponent(v))
}
return ret.join("&")
JAVASCRIPT
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
  database = snowflake_database.snowalert.name
  schema   = snowflake_schema.rules.name
  name     = "has_no_violations"

  arguments {
    name = "qid"
    type = "VARCHAR"
  }

  language    = "SQL"
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
