provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "my-alb-sg" {
  name   = "my-alb-new-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "inbound_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.my-alb-sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.my-alb-sg.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.my-alb-sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_alb" "alb" {
  name = "prod-alb-new-lb"
  subnets = [
    "${var.subnet1}",
    "${var.subnet2}",
  ]
  security_groups = ["${aws_security_group.my-alb-sg.id}"]
  internal        = "false"
  tags = {
    Name = "prod-alb"
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = "alb-prod-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    name = "alb-prod-tg"
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "80"
  }
}


resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = ["aws_alb_target_group.alb_target_group"]
  listener_arn = aws_alb_listener.alb_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.id
  }
  condition {
    path_pattern {
      values = ["*images*"]
    }
  }
}

resource "aws_alb_listener_rule" "listener_rule1" {
  depends_on   = ["aws_alb_target_group.alb_target_group"]
  listener_arn = aws_alb_listener.alb_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.id
  }
  condition {
    path_pattern {
      values = ["*work*"]
    }
  }
}
