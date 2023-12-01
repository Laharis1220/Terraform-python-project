variable "cidr" {
   default = "10.0.0.0/16"
}

variable "cidr1" {
   default = "10.0.0.0/24"
}
variable "cidr2" {
   default = ["0.0.0.0/0"]
}

variable "ami_value" {
  default = "ami-0fc5d935ebf8bc3bc"
}

variable "instance_type_value" {
  default = "t2.micro"
}

variable "cidr3" {
   default = "0.0.0.0/0"
}