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

# Tạo Application Load Balancer (ALB)
resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = var.alb_security_group_ids
}

# Tạo Target Group (TG) cho EC2
resource "aws_lb_target_group" "tg" {
  name        = "tg-01"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

# Tạo Listener cho ALB (port 80)
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
