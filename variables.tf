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

variable "snowalert_role_name" {
  type        = string
  description = "Role used to grant ownership to all Snowalert objects."
  default     = "APP_SNOWALERT"
}

variable "handlers" {
  type        = list(string)
  description = "List of handlers to enable."
  default     = []
}

# Correspoding variables of the specified handlers are required
variable "jira_secrets_arn" {
  type        = string
  description = ""
  default     = null
}

variable "slack_secrets_arn" {
  type        = string
  description = ""
  default     = null
}

variable "smtp_secrets_arn" {
  type        = string
  description = ""
  default     = null
}

variable "smtp_driver_from_email_address" {
  type        = string
  description = ""
  default     = null
}

# Optional Variables
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

variable "create_role" {
  type        = bool
  default     = false
  description = "Flag to create role or not."
}

variable "snowalert_user_email" {
  type        = string
  default     = null
  description = "Email of the snowalert Snowflake user."
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}
