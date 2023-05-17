terraform {
  required_version = ">= 1.3.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.38.0"
    }

    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 0.62.0"

      configuration_aliases = [
        snowflake.security_api_integration_role,
        snowflake.security_storage_integration_role,
        snowflake.security_admin_role,
        snowflake.security_alerting_role,
      ]
    }
  }
}
