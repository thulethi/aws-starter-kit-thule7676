##################################################################
#                    GLOBAL VARIABLES
##################################################################
variable "default_tags" {
  description = "Common resource tags."

  type = map(string)
  default = {
    Project     = "ask-training" # same as terraform.tfvars
    Environment = "staging"      # same as terraform.tfvars
    Terraform   = "true"
  }
}

variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name, e.g. `staging`, `production`."
  type        = string
}

variable "zone_name" {
  description = "Hosted DNS zone name, e.g. `project.domain.tld`."
  type        = string
}

variable "zone_delegation_id" {
  description = "Reusable delegation set associated with hosted zone, e.g. `N0725...`."
  type        = string
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id                         = data.aws_caller_identity.current.account_id
  iam_permission_boundary_policy_arn = format("arn:aws:iam::%s:policy/netguru-boundary", local.account_id)
}

# the rest of the variables are in their corresponding modules
