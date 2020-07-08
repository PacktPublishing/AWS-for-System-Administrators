resource "aws_iam_role" "test_iam_role" {
  name = "test_Iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "test-iam-role"
  }
}

resource "aws_iam_instance_profile" "test_iam_profile" {
  name = "test_iam_profile"
  role = "aws_iam_role.test_iam_role.name"
}

resource "aws_iam_role_policy" "test_iam_policy" {
  name = "test_iam_policy"
  role = "aws_iam_role.test_iam_role.id"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_instance" "test_ec2_role" {
  ami                  = "ami-0d5fad86866a3a449"
  instance_type        = "t2.micro"
  iam_instance_profile = "aws_iam_instance_profile.test_iam_profile.name"
  key_name             = "packtpub"
}

