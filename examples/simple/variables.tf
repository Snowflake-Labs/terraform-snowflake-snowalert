# Required Variables
variable "snowflake_account" {
  type        = string
  description = "Snowflake Account."
}

# Optional Variables
variable "aws_region" {
  type        = string
  description = "Region for the AWS resources."
  default     = "us-west-2"
}

variable "env" {
  type        = string
  description = "Dev/Prod/Staging or any other custom environment name."
  default     = "dev"
}

variable "prefix" {
  type        = string
  description = "This will be the prefix used to name the Resources. WARNING: Enter a short prefix in order to prevent name length related restrictions"
  default     = "example"
}

variable "snowalert_warehouse_name" {
  type        = string
  description = "Warehouse for snowalert."
  default     = "SNOWALERT_WAREHOUSE"
}

variable "snowalert_database_name" {
  type        = string
  description = "Database that will be created for all the Snowalert objects."
  default     = "SNOWALERT"
}

variable "create_warehouse" {
  type        = bool
  default     = false
  description = "Flag to create warehouse or not."
}

variable "create_database" {
  type        = bool
  default     = false
  description = "Flag to create database or not."
}

variable "create_user" {
  type        = bool
  default     = false
  description = "Flag to create user or not."
}

variable "create_role" {
  type        = bool
  default     = false
  description = "Flag to create role or not."
}

variable "create_schemas" {
  type        = bool
  default     = false
  description = "Flag to create schemas within the module or not."
}

variable "create_tables" {
  type        = bool
  default     = false
  description = "Flag to create tables within the module or not."
}

variable "data_bucket_arns" {
  type        = list(string)
  default     = []
  description = "List of Bucket ARNs for the s3_reader role to read from."
}

variable "geff_image_version" {
  type        = string
  description = "Version of the GEFF docker image."
  default     = "latest"
}

variable "handlers" {
  type        = list(string)
  description = "List of handlers to enable."
  default     = []
}

# Correspoding variables of the specified handlers are required
variable "jira_secrets_arn" {
  type        = string
  description = "Secrets for JIRA in the specified format with host pinned."
  default     = null
}

variable "slack_secrets_arn" {
  type        = string
  description = "Secrets for slack in the specified format with host pinned."
  default     = null
}

variable "smtp_secrets_arn" {
  type        = string
  description = "Secrets for SMTP server in the specified format with host pinned."
  default     = null
}

variable "smtp_driver_from_email_address" {
  type        = string
  description = "."
  default     = null
}

variable "jira_url" {
  type        = string
  default     = null
  description = "Fallback JIRA project for the JIRA handler."
}

variable "default_jira_project" {
  type        = string
  default     = "SA"
  description = "Fallback JIRA project for the JIRA handler."
}

variable "default_jira_issue_type" {
  type        = string
  default     = "Task"
  description = "Fallback Issue type for the JIRA handler."
}

variable "servicenow_secrets_arn" {
  type        = string
  default     = null
  description = "Secrets for service now in the specified format with host pinned."
}

variable "servicenow_api_url" {
  type        = string
  default     = null
  description = "Service Now API URL."
}

variable "snowalert_user_email" {
  type        = string
  default     = null
  description = "Email of the snowalert Snowflake user."
}

variable "snowalert_warehouse_size" {
  type        = string
  description = "Warehouse size."
  default     = "XSMALL"
}

variable "alerts_merge_schedule" {
  type        = string
  description = "Schedule for the alert merge."
  default     = "0 12 * * *"
}

variable "alert_dispatch_schedule" {
  type        = string
  description = "Schedule for the alert dispatcher task."
  default     = "* * * * *"
}

variable "alert_scheduler_schedule" {
  type        = string
  description = "Schedule for the alert scheduler task."
  default     = "1/15 * * * *"
}

variable "integration_role" {
  type        = string
  description = "Role for creating database level or account level objects."
  default     = "ACCOUNTADMIN"
}

variable "admin_role" {
  type        = string
  description = "Role for creating database level or account level objects."
  default     = "ACCOUNTADMIN"
}

variable "alerting_role" {
  type        = string
  description = "Role for creating schema level objects."
  default     = "ACCOUNTADMIN"
}

variable "ingest_role" {
  type        = string
  description = "Role for creating schema level objects."
  default     = "ACCOUNTADMIN"
}

variable "modeling_role" {
  type        = string
  description = "Role for creating schema level objects."
  default     = "ACCOUNTADMIN"
}

variable "monitoring_role" {
  type        = string
  description = "Role for creating schema level objects."
  default     = "ACCOUNTADMIN"
}

