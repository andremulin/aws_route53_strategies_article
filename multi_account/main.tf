resource "aws_route53_zone" "dev_zone" {
  name = "inc.dev"

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_vpc_dhcp_options" "principal" {
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "principal" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.principal.id
}

resource "aws_vpc_dhcp_options" "secondary" {
  provider            = aws.secondary
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "secondary" {
  provider        = aws.secondary
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.secondary.id
}

resource "aws_route53_vpc_association_authorization" "this" {
  vpc_id  = var.vpc_id_secondary
  zone_id = aws_route53_zone.dev_zone.id
}

resource "aws_route53_zone_association" "this" {
  provider = aws.secondary

  vpc_id  = aws_route53_vpc_association_authorization.this.vpc_id
  zone_id = aws_route53_vpc_association_authorization.this.zone_id
}