##################################################################
#                          MODULE
##################################################################
module "s3" {
  # hint: source path contains module name in the repository
  source = "git::git@github.com:netguru/terraform-modules.git//s3?ref=v7.0.13"

  bucket            = format("%s-frontend-%s-%s", var.project, var.environment, random_string.www_bucket.id)
  enable_versioning = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.default_tags
}

# used to reduce possibility of name collision in training deployments
resource "random_string" "www_bucket" {
  length  = 7
  lower   = true
  upper   = false
  special = false
}


##################################################################
#                       S3 outputs
##################################################################
output "s3_bucket_arn" {
  value = module.s3.this_s3_bucket_arn
}

output "s3_bucket_bucket_regional_domain_name" {
  value = module.s3.this_s3_bucket_bucket_regional_domain_name
}

output "s3_bucket_hosted_zone_id" {
  value = module.s3.this_s3_bucket_hosted_zone_id
}

output "s3_bucket_id" {
  value = module.s3.this_s3_bucket_id
}

output "s3_bucket_origin_access_identity_path" {
  value = module.s3.this_s3_bucket_origin_access_identity_path
}

output "s3_bucket_region" {
  value = module.s3.this_s3_bucket_region
}

output "s3_bucket_website_domain" {
  value = module.s3.this_s3_bucket_website_domain
}
