# Copyright OCT-2023 JMMB
# limitations under the License.
# Terraform Output Values

# EC2 Instance Public IP
output "instance_publicip" {
  description = "EC2 Instance Public IP"
  value = aws_instance.ec2.public_ip
}

# EC2 Instance Public DNS
output "instance_publicdns" {
  description = "EC2 Instance Public DNS"
  value = aws_instance.ec2.public_dns
}


output "eip_address" {
  description = "Public IP"
  value = aws_eip.eipec2.address
}

output "sg_input" {
  description = "Input SG from local"
  value = aws_security_group.sg_bastion_input.id
}

output "sg_input_web" {
  description = "Input SG from internet"
  value = aws_security_group.sg_bastion_input_web.id
}

