##################################################################
#                  ACM only for ECS LB
##################################################################
module "acm-ecs" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  # hint: configure similarily to CloudFront EXCEPT FOR us-east-1 PROVIDER

  tags = var.default_tags
}
