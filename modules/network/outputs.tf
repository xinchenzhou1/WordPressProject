output "word-press-vpc"{
    value = aws_vpc.word-press-vpc
}
output "public-subnet-1"{
    value = aws_subnet.public-subnet-1
}
output "public-subnet-2"{
    value = aws_subnet.public-subnet-2
}
output "app-subnet-1"{
    value = aws_subnet.app-subnet-1
}
output "app-subnet-2"{
    value = aws_subnet.app-subnet-2
}
output "database-subnet-1"{
    value = aws_subnet.database-subnet-1
}
output "database-subnet-2"{
    value = aws_subnet.database-subnet-2
}