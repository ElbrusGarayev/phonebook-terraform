resource "aws_lb" "auto-load-balancer-backend" {
  name               = "auto-load-balancer-backend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.webserver-security-group.id,
    aws_security_group.ssh-security-group.id
  ]

  subnets = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name        = "auto-load-balancer-backend"
    Environment = "production"
  }
}

resource "aws_lb_listener" "http_backend" {
  load_balancer_arn = aws_lb.auto-load-balancer-backend.arn
  port              = 80

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "There's nothing here"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "my_app_backend" {
  listener_arn = aws_lb_listener.http_backend.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load-balancer-target-group-backend.arn
  }

  condition {
    host_header {
      values = ["myapp.example.com"]
    }
  }
}

resource "aws_lb_target_group" "load-balancer-target-group-backend" {
  vpc_id   = aws_vpc.vpc.id
  name     = "load-balancer-target-group"
  port     = 80
  protocol = "HTTP"
}

resource "aws_lb" "auto-load-balancer-frontend" {
  name               = "auto-load-balancer-frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.webserver-security-group.id,
    aws_security_group.ssh-security-group.id
  ]

  subnets = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name        = "auto-load-balancer-frontend"
    Environment = "production"
  }

  depends_on = [aws_lb.auto-load-balancer-backend]

}

resource "aws_lb_listener" "http_frontend" {
  load_balancer_arn = aws_lb.auto-load-balancer-frontend.arn
  port              = 80

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "There's nothing here"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "my_app_frontend" {
  listener_arn = aws_lb_listener.http_frontend.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load-balancer-target-group-frontend.arn
  }

  condition {
    host_header {
      values = ["myapp.example.com"]
    }
  }
}

resource "aws_lb_target_group" "load-balancer-target-group-frontend" {
  vpc_id   = aws_vpc.vpc.id
  name     = "load-balancer-target-group"
  port     = 80
  protocol = "HTTP"
}