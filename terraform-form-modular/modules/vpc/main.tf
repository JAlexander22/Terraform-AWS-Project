# @component CalculatorApp:VPC (#vpc)
resource "aws_vpc" "cyber94_jalexander_cal_2_vpc_tf" {
    cidr_block = "10.8.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "cyber94_jalexander_cal_2_vpc"
    }
}

resource "aws_internet_gateway" "cyber94_jalexander_cal_2_ig_tf" {
  vpc_id = aws_vpc.cyber94_jalexander_cal_2_vpc_tf.id

  tags = {
    Name = "cyber94_jalexander_cal_2_ig"
  }

}

resource "aws_route_table" "cyber94_jalexander_cal_2_internet_rt_tf" {
    vpc_id = aws_vpc.cyber94_jalexander_cal_2_vpc_tf.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.cyber94_jalexander_cal_2_ig_tf.id
    }

    tags = {
      Name = "cyber94_jalexander_cal_2_internet_rt"
    }
}

resource "aws_route53_zone" "cyber94_jalexander_cal_2_vpc_dns_tf" {
  name = "cyber-8.sparta"

  vpc {
    vpc_id = aws_vpc.cyber94_jalexander_cal_2_vpc_tf.id
  }
}
