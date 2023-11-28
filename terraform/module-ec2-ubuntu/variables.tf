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

variable "tags" {
  type    = map(string)
  default = {}
}

variable "instance_role" {
  description = "Purpose of the instance (backend or database)"
  type        = string
}
