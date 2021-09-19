resource "aws_autoscaling_group" "consul" {
  name = "consul"

  vpc_zone_identifier = [aws_subnet.public.id]

  desired_capacity = 3
  max_size         = 3
  min_size         = 3

  launch_template {
    id      = aws_launch_template.consul.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "consul" {
  name = "consul"

  image_id               = "ami-03d5c68bab01f3496"
  instance_type          = "t3.small"
  key_name               = aws_key_pair.sglodek.id
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.consul.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.consul.arn
  }

  user_data = filebase64("${path.module}/user_data/consul.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Consul Server - sglodek"
      role = "consul_server"
    }
  }
}

resource "aws_iam_instance_profile" "consul" {
  name = "consul"
  role = aws_iam_role.consul.name
}

resource "aws_iam_role" "consul" {
  name = "consul"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}