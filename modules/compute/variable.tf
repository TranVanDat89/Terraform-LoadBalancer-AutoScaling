variable "ami" {
  type = string
  description = "AMI of EC2"
}

variable "key_name" {
  type = string
  nullable = false
  description = "Name of keypair"
}

variable "instance_type" {
  type = string
  description = "Type of EC2 instance"
  default = "t2.micro"
}

variable "ec2_security_group_ids" {
  type = list(string)
  nullable = false
}

variable "target_group_arn_01" {
  type = string
  nullable = false
}
variable "target_group_arn_02" {
  type = string
  nullable = false
}