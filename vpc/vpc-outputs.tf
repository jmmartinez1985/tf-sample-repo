# VPC Output Values

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr" {
  description = "List of IDs of cidr private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_db_subnets" {
  description = "List of IDs of database private subnets"
  value       = module.vpc.database_subnets
}

output "private_db_subnets_group_name" {
  description = "Subnet group database name"
  value       = module.vpc.database_subnet_group_name
}

output "private_db_subnets_cidr" {
  description = "List of IDs of cidr database private subnets"
  value       = module.vpc.database_subnets_cidr_blocks
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

output "private_routetable" {
  description = "List of IDs of private routetables id"
  value       = module.vpc.private_route_table_ids
}

output "public_routetable" {
  description = "List of IDs of public routetables id"
  value       = module.vpc.public_route_table_ids
}

output "private_db_routetable" {
  description = "List of IDs of private database routetables id"
  value       = module.vpc.database_route_table_ids
} 

output "vgw_gateway_id" {
  description = "Virtual Private Gateway ID"
  value = module.vpc.vgw_id
}

output "default_security_group_id" {
  description = "Default security group"
  value = module.vpc.default_security_group_id
}