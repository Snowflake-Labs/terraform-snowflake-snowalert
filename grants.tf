# GRANT ROLE {role} TO USER {user};
# GRANT ALL PRIVILEGES ON DATABASE {database} TO ROLE {role};
# GRANT ALL PRIVILEGES ON WAREHOUSE {warehouse} TO ROLE {role};

# Account
# GRANT EXECUTE TASK ON ACCOUNT TO ROLE {role};

resource "snowflake_account_grant" "account_grant" {
  roles             = [var.role]
  privilege         = "EXECUTE TASK"
  with_grant_option = false
}

# # data
# GRANT ALL PRIVILEGES
# ON ALL SCHEMAS
# IN DATABASE {database}
# TO ROLE {role};

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
