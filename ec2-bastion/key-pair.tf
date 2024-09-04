resource "aws_key_pair" "key-tf" {
  key_name= var.instance_keypair
  public_key = file("${path.module}/key/terraform.pub")

}