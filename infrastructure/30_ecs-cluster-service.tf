##################################################################
#                       VARIABLES
##################################################################
variable "container_image" {
  description = "Container image with version, e.g. `nginx:latest`."
  type        = string
}

variable "task_cpu" {
  description = "Amount of CPU units assigned to particular task, e.g. 1024 is 1 VCPU."
  type        = number
}

variable "task_memory" {
  description = "Amount of memory units assigned to particular task."
  type        = number
}

variable "service_web_container_port" {
  description = "Port that app exposes."
  type        = number
}

variable "healthcheck_path" {
  description = "Healthcheck path that app exposes."
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name."
  type        = string
}

variable "slack_webhook_url" {
  description = "Slack webhook used for notification."
  type        = string
}



##################################################################
#                        MODULE
##################################################################
module "ecs-cluster-service" {
  depends_on = [module.ecs-cluster, module.ssm-param-store]
  source     = "git::git@github.com:netguru/terraform-modules.git//ecs-cluster-service?ref=v7.0.13"

  project_name = var.project
  environment  = var.environment
  aws_region   = data.aws_region.current.name

  service_name = var.ecs_service_name

  container_image = var.container_image
  domains         = [format("api.%s", local.dns_zone)]

  health_check_path      = var.healthcheck_path
  service_container_port = var.service_web_container_port
  task_cpu               = var.task_cpu
  task_memory            = var.task_memory

  ecs_cluster_arn  = "..."
  ecs_cluster_name = "..."

  # hint: cluster load balancer configuration is missing here

  # ^^^

  parameter_store_secrets = [for var, arn in module.ssm-param-store.arn_map : { name : var, arn : arn }]
  vpc_id                  = module.vpc.vpc_id

  iam_permission_boundary_policy_arn = local.iam_permission_boundary_policy_arn
}


##################################################################
#                       OUTPUTS
##################################################################
output "ecs_backend_service_ecr_arn" {
  value = module.ecs-cluster-service.ecr_arn
}

output "ecs_backend_service_ecr_url" {
  value = module.ecs-cluster-service.ecr_url
}
