data "terraform_remote_state" "vpc" {
  backend = "s3"
  workspace = "${lower(terraform.workspace)}"
  config = {
    bucket = "ban-iac-tf-persistance-states-sbox-bucket"
    key    = "vpc/vpc.tfstate"
    region = "us-east-1"
  }
} 