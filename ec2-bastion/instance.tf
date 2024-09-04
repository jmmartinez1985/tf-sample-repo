# EC2 Instance
resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data = file("${path.module}/init/app1-install.sh")
  key_name = aws_key_pair.key-tf.key_name
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  vpc_security_group_ids = [ aws_security_group.sg_bastion_input.id, aws_security_group.sg_bastion_input_web.id  ]
  tags = {
    "Name" = var.instance_name
  }
  lifecycle {
    create_before_destroy = true
  }
  #iam_instance_profile = aws_iam_instance_profile.profile.name
  depends_on = [aws_key_pair.key-tf]
}

resource "aws_eip" "eipec2" {
  instance = aws_instance.ec2.id
  domain   = "vpc"
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [ aws_instance.ec2 ]
}