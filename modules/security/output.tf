output "lab_security_group" {
  value = aws_security_group.lab_security_group.id
}

output "alb_security_group" {
  value = aws_security_group.alb_sg.id
}