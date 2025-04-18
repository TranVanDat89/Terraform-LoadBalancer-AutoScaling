resource "aws_instance" "lab-instance" {
  count = 2
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.ec2_security_group_ids
  user_data = file("${path.module}/userdata1.sh")
  tags = {
    Name = "Lab Demo ${count.index + 1}" # Tên sẽ là Lab Demo 1, Lab Demo 2
  }
}

# Attach từng instance vào đúng Target Group
resource "aws_lb_target_group_attachment" "lab" {
  count = length(aws_instance.lab-instance)

  target_group_arn = var.target_group_arn_01
  target_id        = aws_instance.lab-instance[count.index].id
  port             = 80
}

# Tạo 1 AMI từ instance
resource "aws_ami_from_instance" "lab_instance_ami" {
  name                = "lab-instance-ami-2025"
  source_instance_id  = aws_instance.lab-instance[0].id
  snapshot_without_reboot = true

  depends_on = [
    aws_instance.lab-instance
  ]

  tags = {
    Name = "Lab Instance AMI"
  }
}