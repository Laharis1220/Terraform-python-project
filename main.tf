resource "aws_s3_bucket" "s3_bucket" {
  bucket = "lahari-s3-terraform-1220" 
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
resource "aws_key_pair" "example" {
  key_name = "terraform-demo"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}
resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.cidr1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
  cidr_block = var.cidr3
  gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}
resource "aws_security_group" "webSg" {
  name = "web"
  vpc_id = aws_vpc.myvpc.id
  ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.cidr2
  }
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.cidr2
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.cidr2
  }
  tags = {
    Name = "Web-sg"
  }
}
resource "aws_instance" "webserver" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  key_name = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id = aws_subnet.sub1.id
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")  
    host        = self.public_ip
  }
provisioner "file" {
    source ="app.py"
    destination = "/home/ubuntu/app.py"
}
provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",
      "sudo apt-get install -y python3-pip",
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py",
    ]
}
}
