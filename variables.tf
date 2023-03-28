# Required Variables
variable "prefix" {
  type        = string
  description = "This will be the prefix used to name the Resources."
}

# Optional Variables
variable "env" {
  type        = string
  description = "Dev/Prod/Staging or any other custom environment name."
  default     = "dev"
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

variable "snowalert_user_name" {
  type        = string
  description = "User used to grant ownership to all Snowalert objects."
  default     = "APP_SNOWALERT"
}

variable "aws_region" {
  description = "The AWS region in which the AWS infrastructure is created."
  default     = "us-west-2"
}

variable "aws_cloudwatch_metric_namespace" {
  type        = string
  description = "prefix for CloudWatch Metrics that GEFF writes"
  default     = "*"
}

variable "log_retention_days" {
  description = "Log retention period in days."
  default     = 0 # Forever
}

variable "snowflake_integration_user_roles" {
  type        = list(string)
  default     = []
  description = "List of roles to which GEFF infra will GRANT USAGE ON INTEGRATION perms."
}

variable "deploy_lambda_in_vpc" {
  type        = bool
  description = "The security group VPC ID for the lambda function."
  default     = false
}

variable "lambda_security_group_ids" {
  type        = list(string)
  default     = []
  description = "The security group IDs for the lambda function."
}

variable "lambda_subnet_ids" {
  type        = list(string)
  default     = []
  description = "The subnet IDs for the lambda function."
}

variable "geff_image_version" {
  type        = string
  description = "Version of the GEFF docker image."
  default     = "latest"
}

variable "data_bucket_arns" {
  type        = list(string)
  default     = []
  description = "List of Bucket ARNs for the s3_reader role to read from."
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

variable "snowalert_user_email" {
  type        = string
  default     = null
  description = "Email of the snowalert Snowflake user."
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

variable "snowalert_warehouse_size" {
  type        = string
  description = "Warehouse size."
  default     = "X-Small"
}

variable "alerts_merge_schedule" {
  type        = string
  description = "Schedule for the alert merge."
  default     = "0 12 * * *"
}

variable "alert_processor_schedule" {
  type        = string
  description = "Schedule for the alert processor task."
  default     = "* * * * *"
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

variable "violation_scheduler_schedule" {
  type        = string
  description = "Schedule for the violation scheduler task."
  default     = "1/15 * * * *"
}

variable "security_integration_role" {
  type        = string
  description = "Role for creating database level or account level objects."
  default     = "SECURITY_INTEGRATION_OWNER_RL"
}

variable "security_admin_role" {
  type        = string
  description = "Role for creating database level or account level objects."
  default     = "SECURITY_ADMIN_RL"
}

variable "security_alerting_role" {
  type        = string
  description = "Role for creating schema level objects."
  default     = "SECURITY_ALERTING_RL"
}

variable "security_ingest_role" {
  type        = string
  description = "Role for creating schema level objects."
  default     = "SECURITY_INGEST_RL"
}

variable "security_modeling_role" {
  type        = string
  description = "Role for creating schema level objects."
  default     = "SECURITY_MODELING_RL"
}

variable "security_monitoring_role" {
  type        = string
  description = "Role for creating schema level objects."
  default     = "SECURITY_MONITORING_RL"
}

variable "warehouse_external_roles" {
  type        = list(string)
  description = "List of additional roles that need SnowAlert warehouse usage permissions."
  default     = []
}

variable "arn_format" {
  type        = string
  description = "ARN format could be aws or aws-us-gov. Defaults to non-gov."
  default     = "aws"
}

variable "jira_api_version" {
  type        = string
  description = "Version of the JIRA API to use"
  default     = "3"
}

variable "enable_multiple_grants" {
  type        = bool
  description = "Allow grants outside of the terraform-snowflake-snowalert-rbac module"
  default     = true
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}

locals {
  snowalert_secret_arns = flatten([
    contains(var.handlers, "jira") == true ? [var.jira_secrets_arn] : [],
    contains(var.handlers, "slack") == true ? [var.slack_secrets_arn] : [],
    contains(var.handlers, "servicenow") == true ? [var.servicenow_secrets_arn] : [],
    contains(var.handlers, "smtp") == true ? [var.smtp_secrets_arn] : [],
  ])
}
