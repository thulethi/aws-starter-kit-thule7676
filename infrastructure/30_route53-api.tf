resource "aws_route53_record" "api" {
  depends_on = [module.ecs-cluster-service]

  zone_id = aws_route53_zone.project_zone.zone_id
  name    = format("api.%s", local.dns_zone)
  type    = "A"

  alias {
    # hint: make sure to reference ECS cluster load balancer
    name                   = "..."
    zone_id                = "..."
    evaluate_target_health = false
  }
}

output "route53_api_url" {
  value = format("api.%s", local.dns_zone)
}
