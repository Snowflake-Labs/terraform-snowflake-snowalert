# As mentioned here from the tf snowflake provider:
# https://registry.terraform.io/providers/chanzuckerberg/snowflake/latest/docs#keypair-authentication-passhrase
# The following variables you need to set up in the environment:
# export SNOWFLAKE_USER="snowflake_username"
# export SNOWFLAKE_PRIVATE_KEY_PATH="~/.ssh/snowflake_key.p8"
# export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE="snowflake_passphrase"

provider "snowflake" {
  alias = "security_api_integration_role"

  account = var.snowflake_account
  role    = var.integration_role
}

provider "snowflake" {
  alias = "security_storage_integration_role"

  account = var.snowflake_account
  role    = var.integration_role
}

provider "snowflake" {
  alias = "security_admin_role"

  account = var.snowflake_account
  role    = var.admin_role
}

provider "snowflake" {
  alias = "security_alerting_role"

  account = var.snowflake_account
  role    = var.alerting_role
}
