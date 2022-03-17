output "vpc_id" {
  description = "for my vpc id"
  value = aws_vpc.ILSVPC.id 
}
output "vpc_cidrblock" {
  value = aws_vpc.ILSVPC.cidr_block
}
output "websubnet_id" {
  value = aws_subnet.WebsubnetILS1.*.id
}
