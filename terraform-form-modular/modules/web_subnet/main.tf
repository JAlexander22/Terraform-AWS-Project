resource "aws_subnet" "cyber94_jalexander_cal_2_subnet_web_tf" {
  vpc_id = var.var_aws_vpc_id
  cidr_block = "10.8.1.0/24"

  tags = {
    Name = "cyber94_jalexander_cal_2_subnet_web"
  }
}

resource "aws_route_table_association" "cyber94_jalexander_cal_2_subnet_web_assoc_tf" {
  subnet_id = aws_subnet.cyber94_jalexander_cal_2_subnet_web_tf.id
  route_table_id = var.var_internet_route_table

}
