variable "k3s_bootstrap" {
    type    = bool
    default = false
}

variable "asg_count" {
    type = map(string)
}