##################################################################
#                       VARIABLES
##################################################################
variable "aws_vpc_name" {
  description = "VPC descriptive name."
  type        = string
  default     = "vpc"
}


##################################################################
#                        MODULE
##################################################################
module "vpc" {
  source = "git::git@github.com:netguru/terraform-modules.git//vpc?ref=v7.0.13"

  vpc_name = "${var.project}-${var.environment}-${var.aws_vpc_name}"

  enable_nat_gateway  = false
  enable_nat_instance = true # save $$$

  vpc_tags = var.default_tags

  iam_permission_boundary_policy_arn = local.iam_permission_boundary_policy_arn
}

##################################################################
#                       VPC outputs
##################################################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_private_subnets" {
  value = module.vpc.vpc_private_subnets
}

output "vpc_private_subnets_cidr" {
  value = module.vpc.vpc_private_subnets_cidr
}

output "vpc_public_subnets" {
  value = module.vpc.vpc_public_subnets
}

output "vpc_public_subnets_cidr" {
  value = module.vpc.vpc_public_subnets_cidr
}
