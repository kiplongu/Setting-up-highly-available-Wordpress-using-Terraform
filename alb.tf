resource "aws_lb" "niginx-alb" {
  name                       = "niginx-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = ["subnet-0e3576770692f7860", "subnet-0b70f69048d89c0ad"]
  security_groups            = ["sg-0e701ad951ac390bd"]
  enable_deletion_protection = false
  tags = {
    Name = "Nginx-alb"
  }
}

resource "aws_lb_target_group" "niginx-alb" {
  name     = "niginx-alb"
  port     = 80
  protocol = "HTTP"
  stickiness {
    type = "lb_cookie"
  }
  vpc_id = "vpc-0a3e1bb67ef392750"
}


resource "aws_lb_listener" "niginx-alb" {
  load_balancer_arn = aws_lb.niginx-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.niginx-alb.arn
  }
}
