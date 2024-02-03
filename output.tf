# Step 10 - Add output variables
output "public_ip" {
  value = aws_instance.my_amazon.public_ip
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.web_alb.dns_name
}

output "security_group_id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.alb_sg.id
}
