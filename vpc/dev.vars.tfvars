#COMMON TAGS
tags={
    source = "terraform"
    stage= "development"
}

companycode = "ban"

nattags = {
    Name = "nat-gwy-vpc"
    stage= "development"
  }

iwgtags = {
    Name = "int-gwy-vpc"
    stage= "development"
  }

eiptag = {
    Name = "eip-nat-vpc"
    stage= "development"
  }

private-subnettags = {
    Name = "Private"
    stage= "development"
    peering ="enabled"
  }

private-db-subnettags = {
    Name = "Private DB"
    stage= "development"
  }

public-subnettags = {
    Name = "Public"
    stage= "development"
  }

private_routetableags ={
    Name = "Route Table Private"
    stage= "development"
  }

private_db_routetableags = {
    Name = "Route Table DB Private"
    stage= "development"
  }

public_routetableags = {
    Name = "Route Table Public"
    stage= "development"
  }

vpc_name = "sandbox-vpc"
vpc_cidr_block ="10.39.0.0/16"
vpc_create_database_subnet_group =true
vpc_create_database_subnet_route_table = true
vpc_enable_nat_gateway = false
vpc_single_nat_gateway = false

vpc_enable_vpn_gateway = false



