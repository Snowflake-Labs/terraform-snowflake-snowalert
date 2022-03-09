resource "snowflake_external_function" "snowalert_jira_api" {
  count    = contains(var.handlers, "jira") == true ? 1 : 0
  provider = snowflake.alerting_role

  name     = "SNOWALERT_JIRA_API"
  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name

  arg {
    name = "METHOD"
    type = "STRING"
  }

  arg {
    name = "PATH"
    type = "STRING"
  }

  arg {
    name = "BODY"
    type = "STRING"
  }

  arg {
    name = "QUERYSTRING"
    type = "STRING"
  }

  header {
    name  = "method"
    value = "{0}"
  }

  header {
    name  = "base-url"
    value = var.jira_url
  }

  header {
    name  = "url"
    value = "{1}"
  }

  header {
    name  = "params"
    value = "{3}"
  }

  header {
    name  = "data"
    value = "{2}"
  }

  header {
    name  = "headers"
    value = "content-type=application%2Fjson&accept=application%2Fjson"
  }

  header {
    name  = "auth"
    value = var.jira_secrets_arn
  }

  return_null_allowed       = true
  return_type               = "VARIANT"
  return_behavior           = "VOLATILE"
  api_integration           = module.geff_snowalert.api_integration_name
  url_of_proxy_and_resource = "${module.geff_snowalert.api_gateway_invoke_url}/${var.env}/https"

  comment = <<COMMENT
jira_api: (method, path, body) -> api_response
https://developer.atlassian.com/cloud/jira/platform/rest/v3/
COMMENT
}

resource "snowflake_function" "jira_handler" {
  count    = contains(var.handlers, "jira") == true ? 1 : 0
  provider = snowflake.alerting_role

  name     = "JIRA_HANDLER"
  database = local.snowalert_database_name
  schema   = snowflake_schema.results.name

  arguments {
    name = "ALERT"
    type = "VARIANT"
  }

  arguments {
    name = "PAYLOAD"
    type = "VARIANT"
  }

  return_type     = "VARIANT"
  return_behavior = "IMMUTABLE"

  statement = templatefile(
    "${path.module}/handler_functions_sql/jira_handler.sql", {
      default_jira_project    = var.default_jira_project
      default_jira_issue_type = var.default_jira_issue_type
      database                = local.snowalert_database_name
      schema                  = snowflake_schema.results.name
    }
  )
}
