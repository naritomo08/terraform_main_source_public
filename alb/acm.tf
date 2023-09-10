resource "aws_acm_certificate" "root" {
  domain_name = "web.<ドメイン名>"

  validation_method = "DNS"

  tags = {
    Name = "awsvpc-acn-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "root" {
  certificate_arn = aws_acm_certificate.root.arn
}