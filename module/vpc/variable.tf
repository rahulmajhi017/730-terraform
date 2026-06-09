# Variables For VPC

variable "ports" {
  default = [22, 80, 443]
}

variable "public1_cidr" {
  type = string
  default = "192.168.1.0/24"
}

variable "public2_cidr" {
  type = string
  default = "192.168.2.0/24"
}

variable "private1_cidr" {
  type = string
  default = "192.168.3.0/24"
}

variable "private2_cidr" {
  type = string
  default = "192.168.4.0/24"
}
