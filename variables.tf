variable "aws_profile" {
  type = string
}

variable "whitelisted_ip" {
  type = string
}

variable "k3s_bootstrap" {
  type    = bool
  default = false
}

variable "asg_count" {
  type = map(string)
}