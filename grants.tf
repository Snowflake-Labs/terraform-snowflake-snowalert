# GRANT ROLE {role} TO USER {user};
# GRANT ALL PRIVILEGES ON DATABASE {database} TO ROLE {role};
# GRANT ALL PRIVILEGES ON WAREHOUSE {warehouse} TO ROLE {role};

# Account
# GRANT EXECUTE TASK ON ACCOUNT TO ROLE {role};

# Account
resource "snowflake_account_grant" "account_grant" {
  roles             = [snowflake_role.snowalert.name]
  privilege         = "EXECUTE TASK"
  with_grant_option = false
}

# Database Level
resource "snowflake_database_grant" "db_grant" {
  database_name = snowflake_database.snowalert.name

  privilege = "USAGE"
  roles     = [snowflake_role.snowalert.name]

  with_grant_option = false
}

# Schema Level
resource "snowflake_schema_grant" "schema_grant_usage" {
  database_name = snowflake_database.snowalert.name

  privilege = "USAGE"
  roles     = [snowflake_role.snowalert.name]

  on_future         = true
  with_grant_option = false
}

# Schema Level - ownership
# resource "snowflake_view_grant" "schema_grant_ownership" {
#   database_name = snowflake_database.snowalert.name

#   privilege = "OWNERSHIP"
#   roles     = [snowflake_role.snowalert.name]

#   on_future         = true
#   with_grant_option = false
# }

# View Level - Select
resource "snowflake_view_grant" "view_grant_select" {
  database_name = snowflake_database.snowalert.name

  privilege = "SELECT"
  roles     = [snowflake_role.snowalert.name]

  on_future         = true
  with_grant_option = false
}

# View Level - references
resource "snowflake_view_grant" "view_grant_references" {
  database_name = snowflake_database.snowalert.name

  privilege = "REFERENCES"
  roles     = [snowflake_role.snowalert.name]

  on_future         = true
  with_grant_option = false
}

# View Level - ownership
# resource "snowflake_view_grant" "view_grant_ownership" {
#   database_name = snowflake_database.snowalert.name

#   privilege = "OWNERSHIP"
#   roles     = [snowflake_role.snowalert.name]

#   on_future         = true
#   with_grant_option = false
# }

# Table Level - Select
resource "snowflake_table_grant" "table_grant_select" {
  database_name = snowflake_database.snowalert.name

  privilege = "SELECT"
  roles     = [snowflake_role.snowalert.name]

  on_future         = true
  with_grant_option = false
}

# Table Level - Insert
resource "snowflake_table_grant" "table_grant_insert" {
  database_name = snowflake_database.snowalert.name

  privilege = "INSERT"
  roles     = [snowflake_role.snowalert.name]

  on_future         = true
  with_grant_option = false
}

# Table Level - Ownership
# resource "snowflake_view_grant" "table_grant_ownership" {
#   database_name = snowflake_database.snowalert.name

#   privilege = "OWNERSHIP"
#   roles     = [snowflake_role.snowalert.name]

#   on_future         = true
#   with_grant_option = false
# }

# Procedure Level - Select
# resource "snowflake_procedure_grant" "procedure_grant_ownership" {
#   database_name = snowflake_database.snowalert.name
#   schema_name   = snowflake_schema.results.name

#   privilege = "OWNERSHIP"
#   roles     = [snowflake_role.snowalert.name]

#   on_future         = true
#   with_grant_option = false
# }


# Procedure Level - Usage
resource "snowflake_procedure_grant" "procedure_grant_usage" {
  database_name = snowflake_database.snowalert.name
  schema_name   = snowflake_schema.results.name

  privilege = "USAGE"
  roles     = [snowflake_role.snowalert.name]

  on_future         = true
  with_grant_option = false
}

# Stream Level - SELECT
resource "snowflake_stream_grant" "stream_grant_select" {
  database_name = snowflake_database.snowalert.name
  schema_name   = snowflake_schema.rules.name
  stream_name   = snowflake_stream.raw_alerts_stream.name

  privilege = "SELECT"
  roles     = [snowflake_role.snowalert.name]

  with_grant_option = false
}

# Stream Level - Ownership
# resource "snowflake_stream_grant" "stream_grant_ownerhsip" {
#   database_name = snowflake_database.snowalert.name
#   schema_name   = snowflake_schema.rules.name
#   stream_name   = snowflake_stream.raw_alerts_stream.name

#   privilege = "OWNERSHIP"
#   roles     = [snowflake_role.snowalert.name]

#   with_grant_option = false
# }


# GRANT ALL PRIVILEGES
# ON ALL VIEWS
# IN SCHEMA data
# TO ROLE {role};

# GRANT ALL PRIVILEGES
# ON ALL TABLES
# IN SCHEMA data
# TO ROLE {role};

# GRANT ALL PRIVILEGES
# ON ALL FUNCTIONS
# IN SCHEMA data
# TO ROLE {role};

# # rules
# GRANT OWNERSHIP
# ON ALL VIEWS
# IN SCHEMA rules
# TO ROLE {role};

# GRANT ALL PRIVILEGES
# ON ALL FUNCTIONS
# IN SCHEMA rules
# TO ROLE {role};

# # results
# GRANT ALL PRIVILEGES
# ON ALL TABLES
# IN SCHEMA results
# TO ROLE {role};

# GRANT ALL PRIVILEGES
# ON ALL PROCEDURES
# IN SCHEMA results
# TO ROLE {role};

