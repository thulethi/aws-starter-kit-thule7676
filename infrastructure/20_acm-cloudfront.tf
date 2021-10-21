##################################################################
#                        MODULE
##################################################################
module "acm-cloudfront" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  providers = {
    # CloudFront/Lambda require certificate to be created in us-east-1
    aws = aws.us-east-1
  }

  # hint: access these from locals
  domain_name               = "..."
  subject_alternative_names = ["..."]
  validation_method         = "DNS"

  # hint: look at parent DNS zone outputs
  zone_id = "..."

  tags = var.default_tags
}
