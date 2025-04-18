resource "aws_autoscaling_group" "lab_asg" {
  name                      = "lab-asg"
  min_size                  = var.asg_settings.min_size
  max_size                  = var.asg_settings.max_size
  desired_capacity          = var.asg_settings.desired_capacity
  vpc_zone_identifier       = var.asg_settings.subnet_ids # Subnets để ASG launch instance
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = var.asg_settings.target_group_arns # Gán vào target group
  force_delete              = true # Nếu destroy sẽ xóa luôn các instance

  launch_template {
    id      = var.asg_settings.launch_template_id
    version = "$Latest" # Dùng phiên bản mới nhất của Launch Template
  }

  tag {
    key                 = "Name"
    value               = "Lab ASG Instance"
    propagate_at_launch = true # Tự động gán tag cho các EC2 khi tạo
  }
}

# 2. Auto Scaling Policies
# CPU > 70% → Alarm "cpu-utilization-high" bật → Trigger Policy "scale-out" → tăng thêm 1 instance.
# CPU < 30% → Alarm "cpu-utilization-low" bật → Trigger Policy "scale-in" → giảm 1 instance.
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.lab_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.lab_asg.name
}

# 3. CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This alarm triggers when CPU utilization > 70%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.lab_asg.name
  }
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-utilization-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "This alarm triggers when CPU utilization < 30%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.lab_asg.name
  }
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
}

