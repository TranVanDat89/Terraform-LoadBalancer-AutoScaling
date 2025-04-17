# Terraform-LoadBalancer-AutoScaling
Client Request
    |
    v
+-----------------------------------+
| Application Load Balancer (ALB)   |
| - Listener (port 80)              |
| - Rule: /api/* --> TG-API         |
| - Rule: /web/* --> TG-WEB         |
+-----------------------------------+
       |                           |
+--------------+           +---------------+
| Target Group |           | Target Group  |
|   TG-API     |           |    TG-WEB     |
+--------------+           +---------------+
   |   |   |                   |      |
 EC2 EC2 Lambda             EC2   ECS  Lambda