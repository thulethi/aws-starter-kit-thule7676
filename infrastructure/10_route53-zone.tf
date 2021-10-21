##################################################################
#                        MODULE
##################################################################
resource "aws_route53_zone" "project_zone" {
  name              = var.zone_name
  delegation_set_id = var.zone_delegation_id

  tags = var.default_tags
}

locals {
  training_domain = aws_route53_zone.project_zone.name

  dns_zone                  = format("%s.%s", var.project, local.training_domain)
  subject_alternative_names = [format("*.%s", local.dns_zone)]

  # hint: you can access these variables with `local.NNN`
}


##################################################################
#                       OUTPUTS
##################################################################

output "route53_zone_id" {
  value = aws_route53_zone.project_zone.zone_id
}

output "route53_zone_name_servers" {
  value = aws_route53_zone.project_zone.name_servers
}
