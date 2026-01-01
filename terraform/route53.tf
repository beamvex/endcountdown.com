data "aws_route53_zone" "endcountdown" {
  name         = "endcountdown.com"
  private_zone = false
}

resource "aws_route53_record" "endcountdown_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.endcountdown.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.endcountdown.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]

  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "endcountdown" {
  provider = aws.us_east_1

  certificate_arn = aws_acm_certificate.endcountdown.arn
  validation_record_fqdns = [
    for record in aws_route53_record.endcountdown_acm_validation : record.fqdn
  ]
}

resource "aws_route53_record" "endcountdown_a" {
  zone_id = data.aws_route53_zone.endcountdown.zone_id
  name    = "endcountdown.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "endcountdown_aaaa" {
  zone_id = data.aws_route53_zone.endcountdown.zone_id
  name    = "endcountdown.com"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}
