variable "asg_settings" {
  description = "Auto Scaling Group settings"
  nullable = false
  type = object({
    min_size         = number
    max_size         = number
    desired_capacity = number
    launch_template_id = string
    target_group_arns = list(string)
    subnet_ids = list(string)
  })
}

