output "api_gateway_invoke_url" {
  description = "This is the inferred API Gateway invoke URL which we use as allowed prefixes."
  value       = module.geff_snowalert.api_gateway_invoke_url
}

output "api_integration_name" {
  description = "Name of API integration"
  value       = module.geff_snowalert.api_integration_name
}

output "storage_integration_name" {
  description = "Name of Storage integration"
  value       = module.geff_snowalert.storage_integration_name
}

output "bucket_url" {
  description = "GEFF S3 Bucket URL"
  value       = module.geff_snowalert.bucket_url
}

output "sns_topic_arn" {
  description = "GEFF S3 SNS Topic to use while creating the Snowflake PIPE."
  value       = module.geff_snowalert.sns_topic_arn
}

output "geff_lambda_sg_ids" {
  description = "Lambda SG IDs."
  value       = module.geff_snowalert.geff_lambda_sg_ids
}
