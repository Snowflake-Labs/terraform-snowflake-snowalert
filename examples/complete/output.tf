output "api_gateway_invoke_url" {
  description = "This is the inferred API Gateway invoke URL which we use as allowed prefixes."
  value       = module.snowalert.api_gateway_invoke_url
}

output "api_integration_name" {
  description = "Name of API integration"
  value       = module.snowalert.api_integration_name
}

output "storage_integration_name" {
  description = "Name of Storage integration"
  value       = module.snowalert.storage_integration_name
}

output "bucket_url" {
  description = "GEFF S3 Bucket URL"
  value       = module.snowalert.bucket_url
}

output "sns_topic_arn" {
  description = "GEFF S3 SNS Topic to use while creating the Snowflake PIPE."
  value       = module.snowalert.sns_topic_arn
}

