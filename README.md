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
