# Tạo Application Load Balancer (ALB)
resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.alb_security_group_ids
}

# Tạo Target Group (TG) cho EC2
resource "aws_lb_target_group" "tg" {
  name        = "tg-01"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    matcher             = "200" # Expect HTTP 200
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
