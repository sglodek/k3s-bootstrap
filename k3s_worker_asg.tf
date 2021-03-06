resource "aws_autoscaling_group" "k3s-worker" {
  name = "sglodek-k3s-worker"

  vpc_zone_identifier = [aws_subnet.public.id]

  desired_capacity = var.asg_count["k3s-worker"]
  max_size         = var.asg_count["k3s-worker"]
  min_size         = var.asg_count["k3s-worker"]

  launch_template {
    id      = aws_launch_template.k3s-worker.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "k3s-worker" {
  name = "sglodek-k3s-worker"

  image_id               = "ami-03d5c68bab01f3496"
  instance_type          = "t3.small"
  key_name               = aws_key_pair.sglodek.id
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.k3s-worker.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.consul.arn
  }

  user_data = filebase64("${path.module}/user_data/bootstrap.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "k3s Worker - sglodek"
      role = "k3s-worker"
    }
  }
}