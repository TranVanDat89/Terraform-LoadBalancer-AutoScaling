provider "aws" {
  region = var.region
}

resource "aws_key_pair" "lab-keypair" {
    key_name = "lab-keypair"
    public_key = file(var.keypair_path)
}

module "security" {
  source = "./modules/security"
  region = var.region
}

module "compute" {
  source = "./modules/compute"
  ami = var.ami
  key_name = aws_key_pair.lab-keypair.key_name
  ec2_security_group_ids = [module.security.lab_security_group]
  target_group_arn_01 = module.alb.target_group_01_arn
  target_group_arn_02 = module.alb.target_group_02_arn
}

module "alb" {
  source = "./modules/alb"
  alb_security_group_ids = [module.security.alb_security_group]
}