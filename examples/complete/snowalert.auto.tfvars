# Required
snowflake_account = "oz03309"

# Optional
env            = "dev"
terraform_role = "ACCOUNTADMIN"

snowalert_db_name        = "SNOWALERT"
snowalert_role_name      = "APP_SNOWALERT"
snowalert_warehouse_name = "SNOWALERT_WAREHOUSE"

handlers = [] # ["jira", "slack", "smtp"]

# Correspoding variables of the specified handlers are required
jira_secrets_arn               = ""
slack_secrets_arn              = ""
smtp_secrets_arn               = ""
smtp_driver_from_email_address = ""

