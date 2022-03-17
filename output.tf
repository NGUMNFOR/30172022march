output "public_ip" {
    description = "This is for my public ip"
   value = aws_instance.web.public_ip 
   }

 