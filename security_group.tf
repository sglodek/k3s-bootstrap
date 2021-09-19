resource "aws_security_group" "common" {
  name   = "common-sglodek"
  vpc_id = aws_vpc.k3s.id

  ingress {
    description = "Wireguard VPN SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["52.13.59.179/32"]
  }

  ingress {
    description = "Consul LAN Serf"
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Consul LAN Serf"
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    self        = true
  }

  ingress {
    description = "Server RPC"
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "consul" {
  name   = "consul-sglodek"
  vpc_id = aws_vpc.k3s.id

  ingress {
    description = "WAN Serf"
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "WAN Serf"
    from_port   = 8302
    to_port     = 8302
    protocol    = "udp"
    self        = true
  }
}

resource "aws_security_group" "k3s" {
  name   = "k3s-sglodek"
  vpc_id = aws_vpc.k3s.id

  ingress {
    description = "k3s communcation"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "k3s communcation"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    self        = true
  }

  ingress {
    description = "k3s embedded etc"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    self        = true
  }
}