##################################################################
#                       VARIABLES
##################################################################
variable "auth_enable" {
  description = "(Frontend) Set to true to enable Basic Auth."
  type        = bool
}

variable "auth_username" {
  description = "(Frontend) Basic Auth username."
  type        = string
}

variable "auth_password" {
  description = "(Frontend) Basic Auth password."
  type        = string
}


##################################################################
#                        MODULE
##################################################################
module "cloudfront-s3" {
  depends_on = [module.s3, module.acm-cloudfront]
  source     = "git::git@github.com:netguru/terraform-modules.git//cloudfront-s3?ref=v7.0.13"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  # hint: look at dependencies
  acm_certificate_arn           = "..."
  dns_main_record               = "..."
  dns_subject_alternative_names = []

  # hint: you need to provide source S3 bucket to read from

  # ^^^

  enable_basic_auth   = var.auth_enable
  basic_auth_username = var.auth_username
  basic_auth_password = var.auth_password

  cache_behavior_forwarded_values_query_string    = true
  cache_behavior_forwarded_values_cookies_forward = "all"
  cache_behavior_forwarded_values_headers = [
    "Authorization",
    "Origin",
  ]

  environment = var.environment
  project     = var.project
  tags        = var.default_tags

  iam_permission_boundary_policy_arn = local.iam_permission_boundary_policy_arn
}


##################################################################
#                       OUTPUTS
##################################################################
output "cloudfront_basic_auth_bypass_header_name" {
  value = module.cloudfront-s3.basic_auth_bypass_header_name
}

output "cloudfront_basic_auth_lambda_arn" {
  value = module.cloudfront-s3.basic_auth_lambda_arn
}

output "cloudfront_distribution_arn" {
  value = module.cloudfront-s3.distribution_arn
}

output "cloudfront_distribution_domain_name" {
  value = module.cloudfront-s3.distribution_domain_name
}

output "cloudfront_distribution_hosted_zone_id" {
  value = module.cloudfront-s3.distribution_hosted_zone_id
}
