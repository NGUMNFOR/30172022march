#rootmodule
data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "ILSVPC" {
  cidr_block       = var.vpccidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "ILS_VPC"
  }
}

resource "aws_default_route_table" "privRT" {
  default_route_table_id = aws_vpc.ILSVPC.default_route_table_id

  tags = {
    Name = "privRT"
  }
}


resource "aws_subnet" "WebsubnetILS1" { 
  count = length(var.websubnetnames)
 vpc_id     = aws_vpc.ILSVPC.id
  cidr_block = var.websubnet_cidr[count.index]
  availability_zone =  data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = var.websubnetnames[count.index]
  }
}
resource "aws_subnet" "APPsubnetILS1" {
  count = length(var.Appsubnames)
  vpc_id     = aws_vpc.ILSVPC.id
  cidr_block = var.appsubnet_cidr[count.index]
  availability_zone =  data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = var.Appsubnames[count.index]
  }
}

resource "aws_internet_gateway" "WebILSgw" {
  vpc_id = aws_vpc.ILSVPC.id

  tags = {
    Name = "WebILSgw"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route_table" "WEbILSRT" {
  vpc_id = aws_vpc.ILSVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.WebILSgw.id
  }

  tags = {
    Name = "WEbILSRT"
  }
}
resource "aws_route_table" "AppILSRT" {
  vpc_id = aws_vpc.ILSVPC.id

  tags = {
    Name = "AppILSRT"
  }
}
resource "aws_route_table_association" "ILSRoutetablepub" {
  count = length(var.websubnetnames)
  subnet_id      = aws_subnet.WebsubnetILS1.*.id[count.index]   
  route_table_id = aws_route_table.WEbILSRT.id
}