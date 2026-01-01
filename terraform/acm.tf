# ACM for endcountdown.com
resource "aws_acm_certificate" "endcountdown" {
    provider = aws.us_east_1
    domain_name = "endcountdown.com"
    validation_method = "DNS"
}