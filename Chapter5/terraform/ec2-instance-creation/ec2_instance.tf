provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "prod_instance" {
  ami                    = "ami-067f5c3d5a99edc80"
  instance_type          = "t2.micro"
  key_name               = "vpc-prod"
  vpc_security_group_ids = ["sg-0dabbfc42efb67652"]
  subnet_id              = "subnet-0e87d62c04db49b80"
  user_data              = file("install_apache.sh")
  tags = {
    Name = "prod-server-1"
  }
}
