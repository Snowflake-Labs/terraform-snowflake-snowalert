# Required Variables
variable "snowflake_account" {
  type        = string
  description = "Dev/Prod/Staging or any other custom environment name."
  sensitive   = true
}

# Optional Variables
variable "env" {
  type        = string
  description = "Dev/Prod/Staging or any other custom environment name."
  default     = "dev"
}

variable "terraform_role" {
  type        = string
  description = "Role used to create all the snowalert objects."
  default     = "ACCOUNTADMIN"
}

variable "snowalert_db_name" {
  type        = string
  description = "Database that will be created for all the Snowalert objects."
  default     = "SNOWALERT"
}

variable "snowalert_role_name" {
  type        = string
  description = "Role used to grant ownership to all Snowalert objects."
  default     = "APP_SNOWALERT"
}

variable "snowalert_warehouse_name" {
  type        = string
  description = "Warehouse for snowalert."
  default     = "SNOWALERT_WAREHOUSE"
}

variable "handlers" {
  type        = list(string)
  description = "List of handlers to enable."
  default     = []
}

# Correspoding variables of the specified handlers are required
variable "jira_secrets_arn" {
  type        = string
  description = "."
  default     = null
}

variable "slack_secrets_arn" {
  type        = string
  description = "."
  default     = null
}

variable "smtp_secrets_arn" {
  type        = string
  description = "."
  default     = null
}

variable "smtp_driver_from_email_address" {
  type        = string
  description = "."
  default     = null
}
