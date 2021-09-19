resource "aws_autoscaling_group" "k3s-server" {
  name = "sglodek-k3s-server"

  vpc_zone_identifier = [aws_subnet.public.id]

  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  launch_template {
    id      = aws_launch_template.k3s-server.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "k3s-server" {
  name = "sglodek-k3s-server"

  image_id               = "ami-03d5c68bab01f3496"
  instance_type          = "t3.small"
  key_name               = aws_key_pair.sglodek.id
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.k3s.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.consul.arn
  }

  user_data = filebase64("${path.module}/user_data/k3s_server.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "k3s Server - sglodek"
    }
  }
}