resource "aws_instance" "web" {
  ami           = var.webinstance
  instance_type = var.instancetype
  #subnet_id   = module.vpcmodule.websubnet_id[0]
  # security_groups = [aws_security_group.WebfrontendSGILS.id]
   key_name = aws_key_pair.jan2022.id
   user_data = base64encode(
     templatefile("${path.cwd}/userdata.tpl",
          {      
             vars = []  
              }
              ) )
   tags = {
    Name = format("%s-%s","webinstance", terraform.workspace)
  }
   lifecycle {
    ignore_changes = [
      security_groups,
    ]
  }
}
resource "aws_lb_target_group_attachment" "jenkinstgatt" {
  target_group_arn = aws_lb_target_group.ip_mytg.arn
  target_id        = aws_instance.web.id
  port             = 8080
}

output "web_ip" {
    description = "This is my web ip"
    value = aws_instance.web.public_ip 
}
resource "aws_key_pair" "jan2022" {
  key_name   = "yes"
        public_key = file(var.public_key)
}



