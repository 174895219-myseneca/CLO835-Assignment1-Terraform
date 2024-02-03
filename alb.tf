# Implement an ALB

resource "aws_lb" "web_alb" {
  name               = "${var.prefix}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default.ids

  tags = merge(var.default_tags,
    {
      "Name" = "${var.prefix}-ALB"
    }
  )
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page not found"
      status_code  = "404"
        }
    }
}

# Create Three Target Groups
resource "aws_lb_target_group" "tg1" {
  name     = "${var.prefix}-tg-8081"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 300 
    path                = "/" 
    protocol            = "HTTP"
    timeout             = 5   
    healthy_threshold   = 2   
    unhealthy_threshold = 10  
    matcher             = "200-399" 
  }
}

resource "aws_lb_target_group" "tg2" {
  name     = "${var.prefix}-tg-8082"
  port     = 8082
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  target_type = "instance"
  
  health_check {
    enabled             = true
    interval            = 300 
    path                = "/" 
    protocol            = "HTTP"
    timeout             = 5   
    healthy_threshold   = 2   
    unhealthy_threshold = 10  
    matcher             = "200-399" 
  }
}

resource "aws_lb_target_group" "tg3" {
  name     = "${var.prefix}-tg-8083"
  port     = 8083
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  target_type = "instance"
  
  health_check {
    enabled             = true
    interval            = 300 
    path                = "/" 
    protocol            = "HTTP"
    timeout             = 5   
    healthy_threshold   = 2   
    unhealthy_threshold = 10  
    matcher             = "200-399" 
  }
}

resource "aws_lb_target_group_attachment" "attach_ec2_to_tg1" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.my_amazon.id
  port             = 8081
}

resource "aws_lb_target_group_attachment" "attach_ec2_to_tg2" {
  target_group_arn = aws_lb_target_group.tg2.arn
  target_id        = aws_instance.my_amazon.id
  port             = 8082
}

resource "aws_lb_target_group_attachment" "attach_ec2_to_tg3" {
  target_group_arn = aws_lb_target_group.tg3.arn
  target_id        = aws_instance.my_amazon.id
  port             = 8083
}

# Add listener rules

resource "aws_lb_listener_rule" "listener_rule1" {
  listener_arn = aws_lb_listener.web_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }

  condition {
    path_pattern {
      values = ["/blue/*", "/blue"]
    }
  }
}

resource "aws_lb_listener_rule" "listener_rule2" {
  listener_arn = aws_lb_listener.web_listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg2.arn
  }

  condition {
    path_pattern {
      values = ["/pink/*", "/pink"]
    }
  }
}

resource "aws_lb_listener_rule" "listener_rule3" {
  listener_arn = aws_lb_listener.web_listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg3.arn
  }

  condition {
    path_pattern {
      values = ["/lime/*", "/lime"]
    }
  }
}

