variable "region" {
  type = string
  default = "ap-southeast-2"
}

variable "keypair_path" {
  type = string
  default = "./keypair/lab-keypair.pub"
}

variable "ami" {
    type = string
    description = "This is ami of EC2"
}

variable "number_instances" {
  type = number
  default = 1
}

variable "ami_name_snapshot" {
  type = string
  default = "lab-ami-instance-2025"
}