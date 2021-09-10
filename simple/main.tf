resource "aws_route53_zone" "dev_zone" {
  name = "inc.dev"

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_vpc_dhcp_options" "this" {
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "this" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this.id
}