provider "aws" {
  # this creds already deleted
  access_key = "AKIASKYJ3U2LZHNHEFFR"
  secret_key = "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"
  region     = "us-east-1"
}

###########################################################Create vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "main"
  }
}


resource "aws_subnet" "subnet-task11" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "us-east-1f"
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = "false"
}

resource "aws_subnet" "subnet-second" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.11.0/24"
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

###########################################################Create auto scaling group
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

###########################################################Create application LB
resource "aws_lb" "module11-lb" {
  name               = "module11-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.security_group_1.id}"]
  subnets            = ["${aws_subnet.subnet-task11.id}","${aws_subnet.subnet-second.id}"]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}
