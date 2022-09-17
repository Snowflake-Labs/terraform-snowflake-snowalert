[![Terraform](https://github.com/Snowflake-Labs/snowalert-tf/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/Snowflake-Labs/snowalert-tf/actions/workflows/terraform.yml)

# _snowalert-tf_

![158665186-36fa7acf-fecc-452c-ae4f-482eddf79b72](https://user-images.githubusercontent.com/72515998/158665593-e80b12df-41e2-4162-a102-895ee3407fe8.png)

SnowAlert is an alerting engine that allows you to write SQL queries that are run on schedule and produce alerts into a table that can optionally be dispatched to slack, JIRA or E-mail. It is collection of Snowflake objects that enable you to write what we call _rules_ as Snowflake views that query tables for interesting events to find those that are alertworthy that may then be deemed as _incidents_. We manage these objects in a Terraform module.

It is essentially a Terraformed version of the [Snowalert](https://github.com/snowflakedb/SnowAlert) project. It uses the following Snowflake resources:

1. Views
2. Tables
3. Tasks
4. UDFs
6. Procedures

This version of Snowalert is implemented fully in Snowflake using the above Snowflake native objects to schedule runs of alerts and dispatch them to external services such as slack, JIRA and e-mail using Snowflake External Functions with a [GEFF API](https://github.com/Snowflake-Labs/geff) backend.

### `snowalert.auto.tfvars` Inputs File

A couple of instructions to provide the right set of input variables:

1. _Conditional resources_: warehouse, database, user, role, schemas are conditional resources and hence existing resources can be re-used and provided as input variables. This can be done by setting the `snowalert_*_name` variables to the existing resource names and setting `create_*` variables to `false`(which is the default).
2. _Handlers_: The handlers list is an optional list for those handlers you want created. For each handler provider the corresponding `*_secrets_arn` must be passed and should be created with the specific format required by GEFF with hostname pinned into the secret for added security. Other variables may be conditionally required depending on the handler.

For example, if `handlers = ["jira"]`, you'll additionally have to pass:

- `jira_secrets_arn`
- `jira_url`
- `default_jira_project`
- `default_jira_issue_type`

which are the variables that come into play due to using the JIRA handler. The same follows for serviceNow, slack or SMTP.

A sample tfvars file is provided in the examples. You can copy it and rename it to anything with an extension of `.auto.tfvars` e.g. `snowalert.auto.tfvars`

### Install

```bash
git clone git@github.com:Snowflake-Labs/terraform-snowflake-api-integration-with-geff.git
cd examples/complete

# copy the tfvars file and rename to remove the '.sample' suffix

terraform init

# Import any external resources you want controlled in this module.
# NOTE: The import HAS to be done before plan and apply otherwise the downstream resources will error out at creation.
terraform import snowflake_database.snowalert[0] 'SNOWALERT'
terraform import snowflake_warehouse.snowalert[0] 'SNOWALERT_WAREHOUSE'
# ...

terraform plan -out=snowalert.plan # Use the .auto.tfvars file in the same dir
terraform apply snowalert.plan
```

### Importing Existing Snowflake Resources

This module is designed to work with the following existing resources:

1. Warehouse
1. Database
1. User
1. Role
1. Schemas

There are two ways to use existing resources:

1. _Provide them as inputs_: In this case, they're managed elsewhere and the names of the resources are input as strings through the tfvars file.
1. _Import them into the module_: In this case, they were managed elsewhere and with the import you can manage them within this module. The first step is to `import` these conditional resources and then run the terraform `plan` and `apply`.


### `zsh` function to set environment variables

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

You can then set the appropriate env vars using:

```bash
sfc_env sfc_dev
# or
sfc_env sfc_prod
```

For this function to work, you'll have to place `~/.ssh/sfc_dev_tf_key.p8` and `~/.ssh/sfc_prod_tf_key.p8` keys in your `~/.ssh/` folder.
