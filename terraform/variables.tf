variable "ami" {
  type        = string
  description = "the ami image id"
  default     = "ami-06dd92ecc74fdfb36"
}

variable "app_region" {
  type    = string
  default = "eu-central-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "stephan"
}
