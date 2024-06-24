
provider "aws" {
  region = "ap-southeast-1"
  access_key = "AKIA3FLD2XGSYC5MLEIF"
  secret_key = "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"
}
resource "aws_vpc" "MYVPC7"{
  cidr_block = "172.0.0.0/24"
}
resource "aws_subnet" "sub7"{
  vpc_id = aws_vpc.MYVPC7.id
  cidr_block = "172.0.0.0/28"
}
resource "aws_subnet" "sub8"{
  vpc_id = aws_vpc.MYVPC7.id
  cidr_block = "172.0.0.128/28"
}
resource "aws_internet_gateway" "IGW7"{
  vpc_id = aws_vpc.MYVPC7.id
}
resource "aws_route_table" "RT7"{
  vpc_id = aws_vpc.MYVPC7.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW7.id
  }
}
resource "aws_route_table_association" "RTA7"{
  subnet_id = aws_subnet.sub7.id
  route_table_id = aws_route_table.RT7.id
}


resource "aws_instance" "terraform1"{
  ami = "ami-04c913012f8977029"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub7.id
  key_name = "PVM"
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
  sudo yum install git -y
  sudo yum install python -y
  sudo yum install ansible -y
  sudo git clone https://github.com/kprasantasg87/Devops-20.git
  sudo ansible-playbook -i localhost /Devops-20/ansibleplaybook.yml
  EOF
}
