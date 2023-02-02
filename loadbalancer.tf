## Private Subnet Load Balancer
resource "aws_lb" "app_server_elb" {
  name               = "app-server-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb-sg.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id] #[aws_subnet.app_server_private_az1.id, aws_subnet.app_server_private_az2.id]
}



# Private subnet target group
resource "aws_lb_target_group" "target_group_priv" {
  name        = "my-target-group"
  protocol    = "HTTP"
  port        = 80
  target_type = "instance"
  vpc_id      = aws_vpc.main-vpc.id

  health_check {
    interval            = 15
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener_priv" {
  load_balancer_arn = aws_lb.app_server_elb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_priv.arn
  }
}

output "app_server_loadbalancer" {
  value = aws_lb.app_server_elb.dns_name
}