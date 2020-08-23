provider "aws" {
  region = "us-west-2"
}

resource "aws_launch_configuration" "my-asg-launch-config" {
  image_id        = "ami-0a07be880014c7b8e"
  instance_type   = "t2.micro"
  security_groups = ["sg-0dabbfc42efb67652"]

  user_data = <<-EOF
              #!/bin/bash
              yum -y install httpd
              echo "Hello, from auto-scaling group" > /var/www/html/index.html
              service httpd start
              chkconfig httpd on
              EOF

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "example" {
  name                 = "prod-asg-terraform"
  launch_configuration = aws_launch_configuration.my-asg-launch-config.name
  vpc_zone_identifier  = ["${var.subnet1}", "${var.subnet2}"]
  target_group_arns    = ["${var.target_group_arn}"]
  health_check_type    = "ELB"

  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  tag {
    key                 = "Name"
    value               = "my-test-asg"
    propagate_at_launch = true
  }
}
