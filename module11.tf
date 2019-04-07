provider "aws" {
  access_key = "AKIASKYJ3U2LZHNHEFFR"
  secret_key = "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"
  region     = "us-east-1"
}

###########################################################Create vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet-task11" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "us-east-1f"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "false"
}

###########################################################Create security group
resource "aws_security_group" "security_group_1" {
  name        = "security_group_1"
  description = "Allow http inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

###########################################################Create launch configuration
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "launch-conf-task11" {
  name_prefix   = "launch-conf-task11"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-task11" {
  name                 = "asg-task11"
  launch_configuration = "${aws_launch_configuration.launch-conf-task11.name}"
  min_size             = 2
  max_size             = 5
  vpc_zone_identifier  = ["${aws_subnet.subnet-task11.id}"]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true 
  lifecycle {
    create_before_destroy = true
  }
}

