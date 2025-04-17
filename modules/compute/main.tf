resource "aws_instance" "lab-instance-1" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.ec2_security_group_ids
  user_data = file("${path.module}/userdata1.sh")
  tags = {
    Name = "Lab Demo 1"
  }
}

resource "aws_instance" "lab-instance-2" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.ec2_security_group_ids
  user_data = file("${path.module}/userdata2.sh")
  tags = {
    Name = "Lab Demo 2"
  }
}

# Group instance lại như này
locals {
  instance_target_groups = {
    lab-instance-1 = {
      instance = aws_instance.lab-instance-1
      target_group_arn = var.target_group_arn_01  # tg-01
    }
    lab-instance-2 = {
      instance = aws_instance.lab-instance-2
      target_group_arn = var.target_group_arn_02  # tg-02
    }
  }
}

# Attach từng instance vào đúng Target Group
resource "aws_lb_target_group_attachment" "lab" {
  for_each = local.instance_target_groups

  target_group_arn = each.value.target_group_arn
  target_id        = each.value.instance.id
  port             = 80
}