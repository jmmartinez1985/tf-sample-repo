# Create Security Group - SSH Traffic
resource "aws_security_group" "sg_bastion_input" {
  name        = "vpc-ssh"
  description = "Dev VPC SSH"
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  }
  ingress {
    description = "Allow Port 22 to specific ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.input_ip_address]
  }

  ingress {
    description = "Allow Port 22 to specific ip"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.input_ip_address]
  }

  ingress {
    description = "Allow Port 22 to specific ip"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.input_ip_address]
  }

  egress {
    description = "Allow all ip and ports outbound"    
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-ssh"
  }
  lifecycle {
    create_before_destroy = true
  }
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

# Create Security Group - Web Traffic (PLEASE REMOVE IT LATER)
resource "aws_security_group" "sg_bastion_input_web" {
  name        = "vpc-web"
  description = "Dev VPC Web"
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  egress {
    description = "Allow all ip and ports outbound"    
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-web"
  }
  lifecycle {
    create_before_destroy = true
  }
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

