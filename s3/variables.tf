variable "companycode" {
  default = "dev3"
  description = "Company code organization element"
}

variable "bucket_name_input" {
 description = "bucket name"
 default = "fe-int-s3-file-input-bucket" 
}
variable "bucket_name_output" {
 description = "bucket name"
 default = "fe-int-s3-file-ouput-bucket" 
}

variable "tags" {
  type = map(string)
  default = {
    stage= "development"
  }
}

variable "bucket_versioning_input" {
  type = bool
  description = "Enable bucket versioning"
  default = true
  
}

variable "bucket_lifecycle_input" {
  type = bool
  description = "Enable bucket lifecycle"
  default = true
  
}

variable "bucket_versioning_output" {
  type = bool
  description = "Enable bucket versioning"
  default = true
  
}

variable "bucket_lifecycle_output" {
  type = bool
  description = "Enable bucket lifecycle"
  default = true
  
}