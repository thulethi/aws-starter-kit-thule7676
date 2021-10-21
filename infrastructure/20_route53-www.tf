resource "aws_route53_record" "www" {
  # hint: read from project domain
  zone_id = "..."
  name    = "..."
  type    = "A"

  alias {
    # hint: only reference CDN domain, not project domain
    name                   = "..."
    zone_id                = "..."
    evaluate_target_health = false
  }
}

output "route53_www_url" {
  value = aws_route53_record.www.name
}
