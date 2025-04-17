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