module "aws-geff" {
  source = "../../"

  env    = "dev"
  prefix = "gse_pat"

  snowalert_db_name = "snowalert"
  role              = "app_snowalert"
  warehouse         = "snowalert_warehouse"

  jira_secrets_arn               = ""
  slack_secrets_arn              = ""
  smtp_secrets_arn               = ""
  smtp_driver_from_email_address = ""
}
