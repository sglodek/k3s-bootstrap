resource "aws_autoscaling_group" "k3s-server" {
  name = "sglodek-k3s-server"

  vpc_zone_identifier = [aws_subnet.public.id]

  desired_capacity = var.asg_count["k3s-server"]
  max_size         = var.asg_count["k3s-server"]
  min_size         = var.asg_count["k3s-server"]

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
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.k3s-server.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.consul.arn
  }

  user_data = filebase64("${path.module}/user_data/bootstrap.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "k3s Server - sglodek"
      role      = "k3s-server"
      bootstrap = var.k3s_bootstrap
    }
  }
}