provider "aws" {
  region = var.region
}

# Lấy VPC default
data "aws_vpc" "default" {
  default = true
}

# Lấy các Subnet trong VPC default
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_key_pair" "lab-keypair" {
    key_name = "lab-keypair"
    public_key = file(var.keypair_path)
}

module "security" {
  source = "./modules/security"
  region = var.region
}

module "alb" {
  source = "./modules/alb"
  alb_security_group_ids = [module.security.alb_security_group]
  vpc_id = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids
}

module "compute" {
  source = "./modules/compute"
  ami = var.ami
  key_name = aws_key_pair.lab-keypair.key_name
  ec2_security_group_ids = [module.security.lab_security_group]
  target_group_arn_01 = module.alb.target_group_01_arn
  number_instances = var.number_instances
  ami_name_snapshot = var.ami_name_snapshot
}

module "autoscaling" {
  source = "./modules/autoscaling"
  asg_settings = {
    min_size = 2
    max_size = 4
    desired_capacity = 2
    subnet_ids = data.aws_subnets.default.ids
    target_group_arns = [module.alb.target_group_01_arn]
    launch_template_id = module.compute.launch_template_id
  }
}

