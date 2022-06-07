# Account Level - Execute
# resource "snowflake_account_grant" "account_grant" {
#   provider = snowflake.alerting_role

#   roles             = [local.snowalert_role_name]
#   privilege         = "EXECUTE TASK"
#   with_grant_option = false
# }

# Database Level - Usage
# resource "snowflake_database_grant" "db_grant" {
#   provider = snowflake.alerting_role

#   database_name = local.snowalert_database_name

#   privilege = "USAGE"
#   roles     = [local.snowalert_role_name]

#   with_grant_option = false
# }

# Schema Level - Usage


# View Level - Select
# resource "snowflake_view_grant" "view_grant_select" {
#   provider = snowflake.alerting_role

#   database_name = local.snowalert_database_name

#   privilege = "SELECT"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }

# View Level - references
# resource "snowflake_view_grant" "view_grant_references" {
#   provider = snowflake.alerting_role

#   database_name = local.snowalert_database_name

#   privilege = "REFERENCES"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }

# Table Level - Select
# resource "snowflake_table_grant" "table_grant_select" {
#   provider = snowflake.alerting_role

#   database_name = local.snowalert_database_name

#   privilege = "SELECT"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }

# Table Level - Insert
# resource "snowflake_table_grant" "table_grant_insert" {
#   provider = snowflake.alerting_role

#   database_name = local.snowalert_database_name

#   privilege = "INSERT"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }

# Stream Level - Select
# resource "snowflake_stream_grant" "stream_grant_select" {
#   provider = snowflake.alerting_role

#   database_name = local.snowalert_database_name
#   schema_name   = local.results_schema
#   stream_name   = snowflake_stream.raw_alerts_merge_stream.name

#   privilege = "SELECT"
#   roles     = [local.snowalert_role_name]

#   with_grant_option = false
# }


# ------------------------------------------------------------
# Archived Grants
# ------------------------------------------------------------

# # Stream Level - Ownership
# resource "snowflake_stream_grant" "stream_grant_ownerhsip" {
#   database_name = local.snowalert_database_name
#   schema_name   = local.rules_schema
#   stream_name   = snowflake_stream.raw_alerts_stream.name

#   privilege = "OWNERSHIP"
#   roles     = [local.snowalert_role_name]

#   with_grant_option = false
# }

# Schema Level - ownership
# resource "snowflake_view_grant" "schema_grant_ownership" {
#   database_name = local.snowalert_database_name

#   privilege = "OWNERSHIP"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }

# # Table Level - Ownership
# resource "snowflake_table_grant" "table_grant_ownership" {
#   database_name = local.snowalert_database_name

#   privilege = "OWNERSHIP"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }

# # Procedure Level - Ownership
# resource "snowflake_procedure_grant" "procedure_grant_ownership" {
#   database_name = local.snowalert_database_name
#   schema_name   = local.results_schema

#   privilege = "OWNERSHIP"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }

# # Procedure Level - Usage
# resource "snowflake_procedure_grant" "procedure_grant_usage" {
#   database_name = local.snowalert_database_name
#   schema_name   = local.results_schema

#   privilege = "USAGE"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }


# View Level - ownership
# resource "snowflake_view_grant" "view_grant_ownership" {
#   database_name = local.snowalert_database_name

#   privilege = "OWNERSHIP"
#   roles     = [local.snowalert_role_name]

#   on_future         = true
#   with_grant_option = false
# }


# GRANT ROLE {role} TO USER {user};
# GRANT ALL PRIVILEGES ON DATABASE {database} TO ROLE {role};
# GRANT ALL PRIVILEGES ON WAREHOUSE {warehouse} TO ROLE {role};

# Account
# GRANT EXECUTE TASK ON ACCOUNT TO ROLE {role};


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

