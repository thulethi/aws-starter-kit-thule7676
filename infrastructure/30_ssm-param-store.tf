##################################################################
#                       VARIABLES
##################################################################

variable "backend_secret_key" {
  description = "Value for `X-Secret-Header` header required by backend to accept notifications."
  type        = string
}

##################################################################
#                        MODULE
##################################################################
module "ssm-param-store" {
  source = "git::git@github.com:netguru/terraform-modules.git//ssm-param-store-secrets?ref=v7.0.13"

  project     = var.project
  environment = var.environment

  parameters = {
    FRONTEND_APP_HOST : {
      value : format("https://%s", local.dns_zone)
    },
    CORS_ALLOW_ORIGIN : {
      value : format("https://%s", local.dns_zone)
    },
    SLACK_WEBHOOK_URL : {
      # hint: adjust in tfvars & reference here
      value : "..."
    },
    BACKEND_SECRET_KEY : {
      value : "..."
    },
    PROJECT_NAME : {
      value : "..."
    },
    PROJECT_ENV : {
      value : "..."
    },
  }

  tags = var.default_tags
}
