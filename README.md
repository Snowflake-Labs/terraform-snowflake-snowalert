[![Terraform](https://github.com/Snowflake-Labs/snowalert-tf/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/Snowflake-Labs/snowalert-tf/actions/workflows/terraform.yml)

# _snowalert-tf_

Terraformed version of Snowalert. It creates the following resources:

1. Database
2. Schemas
3. Role
4. Future Grants
5. Task Scheduler, Task Runner and Alert handler UDFs
6. Procedures
7. Tasks

### `snowalert.auto.tfvars` Inputs File

A couple of instructions to provide the right set of input variables:

1. _Conditional resources_: warehouse, database, user, role, schemas are conditional resources and hence existing resources can be re-used and provided as input variables. This can be done by setting the `snowalert_*_name` variables to the existing resource names and setting `create_*` variables to `false`(which is the default).
2. _Handlers_: The handlers list is an optional list for those handlers you want created. For each handler provider the corresponding `*_secrets_arn` must be passed and should be created with the specific format required by GEFF with hostname pinned into the secret for added security. Other variables may be conditionally required depending on the handler.

For example, if `handlers = ["jira"]`, you'll additional have to pass:

- `jira_secrets_arn`
- `jira_url`
- `default_jira_project`
- `default_jira_issue_type`

which are the variables that come into play due to using the JIRA handler. The same follows for serviceNow, slack or SMTP.

### Install

```bash
git clone git@github.com:Snowflake-Labs/terraform-snowflake-api-integration-with-geff.git
cd examples/complete

# copy the tfvars file

terraform init
terraform plan -out=snowalert.plan # no need to pass tfvars file if you have an snowalert.auto.tfvars file
terraform apply snowalert.plan
```



### `zsh` Function

zsh function to set appropriate env variables based on which snowflake you want to target with terraform:

```bash
sfc_env()
{
    case $1 in
        "sfc_dev")
            export SNOWFLAKE_USER=$1_tf_user
            export SNOWFLAKE_PRIVATE_KEY_PATH=
            export SNOWFLAKE_PRIVATE_KEY=`cat ~/.ssh/$1_tf_key.p8`
            export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE='<my private key passphrase>'
            ;;
        "sfc_prod")
            export SNOWFLAKE_USER=$1_tf_user
            export SNOWFLAKE_PRIVATE_KEY_PATH="~/.ssh/$1_tf_key.p8"
            export SNOWFLAKE_PRIVATE_KEY=
            export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE='<my private key passphrase>'
            ;;
        *)
            export SNOWFLAKE_USER=<username>
            export SNOWFLAKE_PRIVATE_KEY_PATH="~/.ssh/$1_tf_key.p8"
            export SNOWFLAKE_PRIVATE_KEY=
            export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE='<my private key passphrase>'
            ;;
    esac
}
```

For this function to work, you'll have to place `~/.ssh/sfc_dev_tf_key.p8` and `~/.ssh/sfc_prod_tf_key.p8` keys in your `~/.ssh/` folder.
