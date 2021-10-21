##################################################################
#                       VARIABLES
##################################################################
variable "instance_type" {
  description = "Type of EC2 used by ECS autoscaling group."
  type        = string
}

variable "desired_capacity" {
  description = "Default amount of instances desired for workload."
  type        = string
}

variable "min_size" {
  description = "Minimal amount of instances to handle workload."
  type        = string
}

variable "max_size" {
  description = "Maximum amount of instances to handle workload - very important to keep costs at bay."
  type        = string
}

variable "detailed_monitoring" {
  description = "Whether to allow detailed cloudwatch metrics to be collected, enabling more detailed alerting."
  type        = string
}



##################################################################
#                        MODULE
##################################################################
module "ecs-cluster" {
  depends_on = [module.vpc, module.acm-ecs]
  source     = "git::git@github.com:netguru/terraform-modules.git//ecs-cluster?ref=v7.0.13"

  cluster_name = var.project
  environment  = var.environment

  instance_type       = var.instance_type
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  detailed_monitoring = var.detailed_monitoring

  # hint: cluster resources should use private network from VPC
  # hint: load balancer needs to be publicly accessible (include lb_subnet_cidrs)
  vpc_id          = "..."
  ecs_subnet_ids  = ["..."]
  lb_subnet_ids   = ["..."]
  lb_subnet_cidrs = ["..."]
  # ^^^

  lb_acm_certificate_name = local.dns_zone # it is looking for in current region, so we need module.acm-ecs

  iam_permission_boundary_policy_arn = local.iam_permission_boundary_policy_arn
}
