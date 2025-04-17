data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = var.alb_security_group_ids
}

resource "aws_lb_target_group" "tg-01" {
  name        = "tg-01"
  port        = 80
  protocol    = "HTTP"
  vpc_id = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "tg-02" {
  name        = "tg-02"
  port        = 80
  protocol    = "HTTP"
  vpc_id = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.tg-01.arn
        weight = 80
      }

      target_group {
        arn    = aws_lb_target_group.tg-02.arn
        weight = 20   
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}
