output "vpc" {
    description = "A reference to the created VPC"
    value = aws_vpc.common_vpc
}
output "publicsubnet1" {
    description = "A reference to the public subnet in the 1st Availability Zone"
    value = aws_subnet.publicsubnet1
}
output "publicsubnet2" {
    description = "A reference to the public subnet in the 2nd Availability Zone"
    value = aws_subnet.publicsubnet2
}
output "privatesubnet1" {
    description = "A reference to the private subnet in the 1st Availability Zone"
    value = aws_subnet.privatesubnet1
}
output "privatesubnet2" {
    description = "A reference to the private subnet in the 2nd Availability Zone"
    value = aws_subnet.privatesubnet2
}
output "publicsubnetlist" {
    description = "A list of public subnets"
    value = join(", ", [aws_subnet.publicsubnet1.cidr_block, aws_subnet.publicsubnet2.cidr_block])
}
output "privatesubnetlist" {
    description = "A list of private subnets"
    value = join(", ", [aws_subnet.privatesubnet1.cidr_block, aws_subnet.privatesubnet2.cidr_block])
}
output "privateavailabilityzones" {
    description = "List of private AZs"
    value = join(", ", [aws_subnet.privatesubnet1.availability_zone, aws_subnet.privatesubnet2.availability_zone])
}