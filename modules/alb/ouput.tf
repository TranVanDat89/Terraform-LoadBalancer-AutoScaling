output "alb_dns" {
  value = aws_lb.alb.dns_name
}
output "target_group_01_arn" {
  value = aws_lb_target_group.tg-01.arn
}
output "target_group_02_arn" {
  value = aws_lb_target_group.tg-02.arn
}