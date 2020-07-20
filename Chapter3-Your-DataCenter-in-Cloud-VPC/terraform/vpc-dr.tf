provider "aws" {
  region = "us-east-2"
}
data "aws_vpc" "vpc-dr" {
  filter {
    name   = "tag:Name"
    values = ["vpc-dr"]
  }

}

data "aws_subnet_ids" "vpc-dr-subnet" {
  vpc_id = data.aws_vpc.vpc-dr.id
}


data "aws_route_table" "vpc-dr-rt" {
  filter {
    name   = "tag:Name"
    values = ["vpc-dr-public-route-table"]
 }
}

resource "aws_ec2_transit_gateway" "tgw-dr" {
  description                     = "transit gateway for DR environment"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "tgw-dr"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-dr-attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw-dr.id
  vpc_id             = data.aws_vpc.vpc-dr.id
  dns_support        = "enable"
  subnet_ids         = data.aws_subnet_ids.vpc-dr-subnet.ids


  tags = {
    Name = "tgw-dr-subnet"
  }
}


resource "aws_route" "my-tgw-route" {
  route_table_id         = data.aws_route_table.vpc-dr-rt.id
  destination_cidr_block = "172.0.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw-dr.id
}
