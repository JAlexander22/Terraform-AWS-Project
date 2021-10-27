provider "aws" {
  region = "eu-west-1"
}


#Virtual Private Cloud
resource "aws_vpc" "cyber94_jalexander_nginx_cal_vpc_tf"{
  cidr_block = "10.208.0.0/16"

  tags = {
    Name = "cyber94_jalexander_nginx_cal_vpc"
  }
}

#Internet gateway
resource "aws_internet_gateway" "cyber94_jalexander_nginx_cal_ig_tf" {
  vpc_id = aws_vpc.cyber94_jalexander_nginx_cal_vpc_tf.id

  tags = {
    Name = "cyber94_jalexander_nginx_cal_ig"
  }
}


#Route Table
resource "aws_route_table" "cyber94_jalexander_nginx_cal_rt_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_nginx_cal_vpc_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cyber94_jalexander_nginx_cal_ig_tf.id
    }
  tags = {
    Name = "cyber94_jalexander_nginx_cal_rt"
  }
}

#subnets
resource "aws_subnet" "cyber94_jalexander_nginx_cal_subnet_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_nginx_cal_vpc_tf.id
  cidr_block = "10.208.1.0/24"

  tags = {
    Name = "cyber94_jalexander_nginx_cal_subnet"
  }
}




#Route table association
resource "aws_route_table_association" "cyber94_jalexander_nginx_cal_rt_assoc_tf" {
    subnet_id = aws_subnet.cyber94_jalexander_nginx_cal_subnet_tf.id
    route_table_id = aws_route_table.cyber94_jalexander_nginx_cal_rt_tf.id
}


#Network Access Control Lists
resource "aws_network_acl" "cyber94_jalexander_nginx_cal_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_nginx_cal_vpc_tf.id

  egress {
      protocol   = "-1"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  egress {
      protocol   = "-1"
      rule_no    = 200
      action     = "deny"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }

  ingress {
      protocol   = "-1"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ingress {
      protocol   = "-1"
      rule_no    = 200
      action     = "deny"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }

  subnet_ids = [aws_subnet.cyber94_jalexander_nginx_cal_subnet_tf.id]

  tags = {
    Name = "cyber94_jalexander_nginx_cal_ncal"
  }
}

#Security Groups
resource "aws_security_group" "cyber94_jalexander_nginx_cal_sg_tf"{
  name = "cyber94_jalexander_nginx_cal_sg"
  description = "Allow Web inbound traffic"
  vpc_id = aws_vpc.cyber94_jalexander_nginx_cal_vpc_tf.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "HTTP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cyber94_jalexander_nginx_cal_sg"
  }
}



#AWS EC2 Instances
resource "aws_instance" "cyber94_jalexander_nginx_cal_proxy"{
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-jalexander"
  associate_public_ip_address = true
  subnet_id = aws_subnet.cyber94_jalexander_nginx_cal_subnet_tf.id

  vpc_security_group_ids = [aws_security_group.cyber94_jalexander_nginx_cal_sg_tf.id]

  tags = {
    Name = "cyber94_jalexander_nginx_cal_proxy"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/kali/.ssh/cyber94-jalexander.pem")
  }

  provisioner "remote-exec"{
    inline = [
      "pwd"
    ]
  }
}
resource "aws_instance" "cyber94_jalexander_nginx_cal_server1"{
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-jalexander"
  associate_public_ip_address = true
  subnet_id = aws_subnet.cyber94_jalexander_nginx_cal_subnet_tf.id

  vpc_security_group_ids = [aws_security_group.cyber94_jalexander_nginx_cal_sg_tf.id]

  tags = {
    Name = "cyber94_jalexander_nginx_cal_server1"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/kali/.ssh/cyber94-jalexander.pem")
  }

  provisioner "remote-exec"{
    inline = [
      "pwd"
    ]
  }
}
resource "aws_instance" "cyber94_jalexander_nginx_cal_server2"{
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-jalexander"
  associate_public_ip_address = true
  subnet_id = aws_subnet.cyber94_jalexander_nginx_cal_subnet_tf.id

  vpc_security_group_ids = [aws_security_group.cyber94_jalexander_nginx_cal_sg_tf.id]

  tags = {
    Name = "cyber94_jalexander_nginx_cal_server2"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/kali/.ssh/cyber94-jalexander.pem")
  }

  provisioner "remote-exec"{
    inline = [
      "pwd"
    ]
  }
}
