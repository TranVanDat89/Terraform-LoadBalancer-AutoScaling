output "alb_dns" {
  value = aws_lb.alb.dns_name
}
output "target_group_01_arn" {
  value = aws_lb_target_group.tg.arn
}