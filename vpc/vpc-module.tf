

data "aws_availability_zones" "available" {}

locals {

  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

}



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"


  # VPC Basic Details
  name = "${var.vpc_name}-${lower(terraform.workspace)}"
  cidr = var.vpc_cidr_block
  azs              = local.azs


  manage_default_route_table = false
  
  #Subnets
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 3)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 6)]





  create_database_subnet_group = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  # create_database_internet_gateway_route = true
  # create_database_nat_gateway_route = true
  
  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.vpc_enable_nat_gateway 
  single_nat_gateway = var.vpc_single_nat_gateway
  
  #TAGS
  nat_gateway_tags = var.nattags
  nat_eip_tags = var.nattags
  igw_tags = var.iwgtags
  public_subnet_tags = var.public-subnettags
  private_subnet_tags = var.private-subnettags
  database_subnet_tags = var.private-db-subnettags
  private_route_table_tags = var.private_routetableags
  public_route_table_tags = var.public_routetableags
  database_route_table_tags = var.private_db_routetableags

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_vpn_gateway = var.vpc_enable_vpn_gateway

  tags = var.tags
  vpc_tags = var.tags


}