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


variable "sagemaker_definition" {
  type = map(object({
    user_profile  = string
    mail = string
  }))
  default = {
    jmmartinez = {
      user_profile  = "jmmartinez"
      mail = "jose.m.martinez@banistmo.com"
    },
    jemartinez = {
      user_profile = "jemartinezz"
      mail  = "jonathan.martinez@banistmo.com"

    }
  }
}

variable "sso_provider_arn" {
  type        = string
  description = "ARN del proveedor SSO existente"
}
