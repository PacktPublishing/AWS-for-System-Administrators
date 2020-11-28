provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "test_instance" {
  ami           = "ami-0bc06212a56393ee1"
  instance_type = "t2.micro"
}
