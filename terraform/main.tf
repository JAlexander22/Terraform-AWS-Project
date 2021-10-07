provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "cyber94-jalexander-bucket"
    key = "tfstate/calc/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "cyber94_jalexander_cal_dynambo_table_lock"
    encrypt = true
  }
}

#Virtual Private Cloud
resource "aws_vpc" "cyber94_jalexander_cal_vpc_tf"{
  cidr_block = "10.108.0.0/16"

  tags = {
    Name = "cyber94_jalexander_cal_vpc"
  }
}


#Internet gateway
resource "aws_internet_gateway" "cyber94_jalexander_cal_ig_tf" {
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id

  tags = {
    Name = "cyber94_jalexander_cal_ig"
  }
}


#Route Table
resource "aws_route_table" "cyber94_jalexander_cal_rt_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cyber94_jalexander_cal_ig_tf.id
    }
  tags = {
    Name = "cyber94_jalexander_cal_rt"
  }
}

#subnets
resource "aws_subnet" "cyber94_jalexander_cal_subnet_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id
  cidr_block = "10.108.1.0/24"

  tags = {
    Name = "cyber94_jalexander_cal_subnet"
  }
}
resource "aws_subnet" "cyber94_jalexander_cal_subnet_db_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id
  cidr_block = "10.108.2.0/24"

  tags = {
    Name = "cyber94_jalexander_cal_subnet_db"
  }
}
resource "aws_subnet" "cyber94_jalexander_cal_subnet_bastion_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id
  cidr_block = "10.108.3.0/24"

  tags = {
    Name = "cyber94_jalexander_cal_subnet_bastion"
  }
}



#Route table association
resource "aws_route_table_association" "cyber94_jalexander_cal_rt_assoc_tf" {
    subnet_id = aws_subnet.cyber94_jalexander_cal_subnet_tf.id
    route_table_id = aws_route_table.cyber94_jalexander_cal_rt_tf.id
}
resource "aws_route_table_association" "cyber94_jalexander_cal_rt_assoc_bastion_tf" {
    subnet_id = aws_subnet.cyber94_jalexander_cal_subnet_bastion_tf.id
    route_table_id = aws_route_table.cyber94_jalexander_cal_rt_tf.id
}


#Network Access Control Lists
resource "aws_network_acl" "cyber94_jalexander_cal_ncal_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id

  egress {
      protocol   = "tcp"
      rule_no    = 1000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 3306
      to_port    = 3306
    }
  egress {
      protocol   = "tcp"
      rule_no    = 2000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }
  egress {
      protocol   = "tcp"
      rule_no    = 3000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    }

  egress {
      protocol   = "tcp"
      rule_no    = 4000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }

  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 5000
      to_port    = 5000
    }
  ingress {
      protocol   = "tcp"
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    }
  ingress {
      protocol   = "tcp"
      rule_no    = 300
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
  subnet_ids = [aws_subnet.cyber94_jalexander_cal_subnet_tf.id]

  tags = {
    Name = "cyber94_jalexander_cal_ncal"
  }
}
resource "aws_network_acl" "cyber94_jalexander_cal_ncal_db_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id

  egress {
       protocol   = "tcp"
       rule_no    = 1000
       action     = "allow"
       cidr_block = "0.0.0.0/0"
       from_port  = 1024
       to_port    = 65535
     }

   ingress {
       protocol   = "tcp"
       rule_no    = 100
       action     = "allow"
       cidr_block = "0.0.0.0/0"
       from_port  = 22
       to_port    = 22
     }
   ingress {
       protocol   = "tcp"
       rule_no    = 200
       action     = "allow"
       cidr_block = "0.0.0.0/0"
       from_port  = 3306
       to_port    = 3306
     }
  subnet_ids = [aws_subnet.cyber94_jalexander_cal_subnet_db_tf.id]

  tags = {
    Name = "cyber94_jalexander_cal_ncal_db"
  }
}
resource "aws_network_acl" "cyber94_jalexander_cal_ncal_bastion_tf"{
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id

  egress {
       protocol   = "tcp"
       rule_no    = 1000
       action     = "allow"
       cidr_block = "0.0.0.0/0"
       from_port  = 22
       to_port    = 22
     }

   egress {
       protocol   = "tcp"
       rule_no    = 2000
       action     = "allow"
       cidr_block = "0.0.0.0/0"
       from_port  = 1024
       to_port    = 65535
     }

   ingress {
       protocol   = "tcp"
       rule_no    = 100
       action     = "allow"
       cidr_block = "0.0.0.0/0"
       from_port  = 22
       to_port    = 22
     }
   ingress {
       protocol   = "tcp"
       rule_no    = 200
       action     = "allow"
       cidr_block = "0.0.0.0/0"
       from_port  = 1024
       to_port    = 65535
     }
  subnet_ids = [aws_subnet.cyber94_jalexander_cal_subnet_bastion_tf.id]

  tags = {
    Name = "cyber94_jalexander_cal_ncal_bastion"
  }
}



#Security Groups
resource "aws_security_group" "cyber94_jalexander_cal_sg_tf"{
  name = "cyber94_jalexander_cal_sg"
  description = "Allow Web inbound traffic"
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id

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
  egress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cyber94_jalexander_cal_sg"
  }
}
resource "aws_security_group" "cyber94_jalexander_cal_sg_db_tf"{
  name = "cyber94_jalexander_cal_sg_db"
  description = "Allow Web inbound traffic"
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cyber94_jalexander_cal_sg_db"
  }
}
resource "aws_security_group" "cyber94_jalexander_cal_sg_bastion_tf"{
  name = "cyber94_jalexander_cal_sg_bastion"
  description = "Allow Web inbound traffic"
  vpc_id = aws_vpc.cyber94_jalexander_cal_vpc_tf.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cyber94_jalexander_cal_sg_bastion"
  }
}



#AWS EC2 Instances
resource "aws_instance" "cyber94_jalexander_cal_app"{
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-jalexander"
  associate_public_ip_address = true
  subnet_id = aws_subnet.cyber94_jalexander_cal_subnet_tf.id

  vpc_security_group_ids = [aws_security_group.cyber94_jalexander_cal_sg_tf.id]

  tags = {
    Name = "cyber94_jalexander_cal_app"
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

  provisioner "local-exec" {
      working_dir = "../ansible"
      command = "ansible-playbook -i ${self.public_ip}, -u ubuntu provisioner.yml"
  }
}
resource "aws_instance" "cyber94_jalexander_cal_db"{
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-jalexander"
  subnet_id = aws_subnet.cyber94_jalexander_cal_subnet_db_tf.id

  vpc_security_group_ids = [aws_security_group.cyber94_jalexander_cal_sg_db_tf.id]

  tags = {
    Name = "cyber94_jalexander_cal_db"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_instance" "cyber94_jalexander_cal_bastion"{
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-jalexander"
  associate_public_ip_address = true
  subnet_id = aws_subnet.cyber94_jalexander_cal_subnet_bastion_tf.id

  vpc_security_group_ids = [aws_security_group.cyber94_jalexander_cal_sg_bastion_tf.id]

  tags = {
    Name = "cyber94_jalexander_cal_bastion"
  }

  lifecycle {
    create_before_destroy = true
  }
}
