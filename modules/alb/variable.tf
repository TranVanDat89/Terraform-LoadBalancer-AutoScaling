variable "alb_security_group_ids" {
  type = list(string)
  nullable = false
}

variable "vpc_id" {
  type = string
  nullable = false
}

variable "subnet_ids" {
  type = list(string)
  nullable = false
}