output "api_gateway_invoke_url" {
  description = "This is the inferred API Gateway invoke URL which we use as allowed prefixes."
  value       = length(module.geff_snowalert) >= 1 ? module.geff_snowalert[0].api_gateway_invoke_url : null
}

output "api_integration_name" {
  description = "Name of API integration"
  value       = length(module.geff_snowalert) >= 1 ? module.geff_snowalert[0].api_integration_name : null
}

output "storage_integration_name" {
  description = "Name of Storage integration"
  value       = length(module.geff_snowalert) >= 1 ? module.geff_snowalert[0].storage_integration_name : null
}

output "bucket_url" {
  description = "GEFF S3 Bucket URL"
  value       = length(module.geff_snowalert) >= 1 ? module.geff_snowalert[0].bucket_url : null
}

output "sns_topic_arn" {
  description = "GEFF S3 SNS Topic to use while creating the Snowflake PIPE."
  value       = length(module.geff_snowalert) >= 1 ? module.geff_snowalert[0].sns_topic_arn : null
}

output "geff_lambda_sg_ids" {
  description = "Lambda SG IDs."
  value       = length(module.geff_snowalert) >= 1 ? module.geff_snowalert[0].geff_lambda_sg_ids : null
}

output "alert_query_rule_run_errors" {
  description = ""
  value       = snowflake_view.alert_query_rule_run_errors.name
}

output "alert_suppression_rule_run_errors" {
  description = ""
  value       = snowflake_view.alert_suppression_rule_run_errors.name
}

output "violation_query_rule_run_errors" {
  description = ""
  value       = snowflake_view.violation_query_rule_run_errors.name
}

output "violation_suppression_rule_run_errors" {
  description = ""
  value       = snowflake_view.violation_suppression_rule_run_errors.name
}
