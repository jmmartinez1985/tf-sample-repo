variable "companycode" {
  default = "dev3"
  description = "Company code organization element"
}


variable "tags" {
  type = map(string)
  default = {
    Name = "sbox-arq"
    stage= "development"
  }
}

