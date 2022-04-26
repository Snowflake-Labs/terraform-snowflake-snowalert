terraform {
  required_version = ">= 1.1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.2.0"
    }

    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.32.0"

      configuration_aliases = [
        snowflake.api_integration_role,
        snowflake.storage_integration_role,
        snowflake.admin_role,
        snowflake.alerting_role,
      ]
    }
  }
}
