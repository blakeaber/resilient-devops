provider "aws" {
  region     = "${var.region}"
  access_key = "***REMOVED***"
  secret_key = "***REMOVED***"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "vedi.today"
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}
