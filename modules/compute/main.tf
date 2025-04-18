resource "aws_instance" "lab-instance" {
  count = var.number_instances
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
# Comment khi đã tạo xong AMI và Launch Template
resource "null_resource" "wait_for_instance" {
  depends_on = [aws_instance.lab-instance]

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /tmp/instance_ready ]; do sleep 5; done"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./keypair/lab-keypair")
      host        = aws_instance.lab-instance[0].public_ip
    }
  }
}


# Tạo 1 AMI từ instance
resource "aws_ami_from_instance" "lab_instance_ami" {
  name                = var.ami_name_snapshot
  source_instance_id  = aws_instance.lab-instance[0].id
  snapshot_without_reboot = true

  depends_on = [
    null_resource.wait_for_instance
  ]

  tags = {
    Name = "Lab Instance AMI"
  }
}

# Nếu dùng count = ...	Dùng [index]
# Nếu dùng for_each = ...	Dùng .each.value
# Khi resource có count, nó biến thành 1 danh sách ([]).
# Terraform bắt buộc bạn chỉ định index [0], [1], v.v.
resource "aws_launch_template" "lab_launch_template" {
  name_prefix   = "lab-launch-template-"
  image_id      = aws_ami_from_instance.lab_instance_ami.id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = var.ec2_security_group_ids

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Lab Instance from Launch Template"
    }
  }
}
