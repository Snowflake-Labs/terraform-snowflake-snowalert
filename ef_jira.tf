resource "snowflake_external_function" "snowalert_jira_api" {
  count    = contains(var.handlers, "jira") == true ? 1 : 0
  provider = snowflake.security_alerting_role

  database = local.snowalert_database_name
  schema   = local.results_schema
  name     = "SNOWALERT_JIRA_API"

  # Function arguments
  arg {
    name = "METHOD"
    type = "VARCHAR"
  }

  arg {
    name = "PATH"
    type = "VARCHAR"
  }

  arg {
    name = "BODY"
    type = "VARCHAR"
  }

  arg {
    name = "QUERYSTRING"
    type = "VARCHAR"
  }

  # Function headers
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
  api_integration           = module.geff_snowalert[0].api_integration_name
  url_of_proxy_and_resource = "${module.geff_snowalert[0].api_gateway_invoke_url}${var.env}/https"

  comment = <<COMMENT
jira_api: (method, path, body) -> api_response
https://developer.atlassian.com/cloud/jira/platform/rest/v3/
or https://developer.atlassian.com/server/jira/platform/rest-apis/
COMMENT

  depends_on = [
    module.snowalert_grants
  ]
}

resource "snowflake_function" "jira_handler" {
  count    = contains(var.handlers, "jira") == true ? 1 : 0
  provider = snowflake.security_alerting_role

  name     = "JIRA_HANDLER"
  database = local.snowalert_database_name
  schema   = local.results_schema

  # Function arguments
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
    "${path.module}/handler_functions_sql/jira_handler_v${var.jira_api_version}.sql", {
      default_jira_project    = var.default_jira_project
      default_jira_issue_type = var.default_jira_issue_type

      jira_api_function = join(".", [
        local.snowalert_database_name,
        local.results_schema,
        snowflake_external_function.snowalert_jira_api[0].name,
      ])
      json_beautify_function = join(".", [
        local.snowalert_database_name,
        local.data_schema,
        snowflake_function.json_beautify_with_indent.name,
      ])
    }
  )

  depends_on = [
    module.snowalert_grants
  ]
}
