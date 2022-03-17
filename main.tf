
/*module "vpcmodule" {
  source = "./vpcmodule"

  vpccidr = var.vpccidr
  websubnetnames  = var.websubnetnames
  Appsubnames     = var.Appsubnames
  websubnet_cidr  = [for each in range(1,225,2) : cidrsubnet(var.vpccidr, 8, each)]
  appsubnet_cidr  = [for each in range(0,225,2) : cidrsubnet(var.vpccidr, 8, each)]
}
*/
resource "aws_security_group" "WebfrontendSGILS" {
  name        = "WebSGILS"
  description = "Allow shh inbound traffic"


  ingress {
    description      = "shh from my ip"
    from_port        = var.WebSG
    to_port          = var.WebSG
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "allow port 8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

   }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
   lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "WebSGILS"
  }
}

resource "aws_security_group" "AppSGILS" {
  name        = "AppSGILS"
  description = "Allow TLS inbound traffic"
  

  ingress {
    description      = "TLS from VPC"
    from_port        = var.AppSG
    to_port          = var.AppSG
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "AppSGILS"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_lb" "Application" {

  name               = "Application-lb-tf"
  internal           = false
  security_groups    = [aws_security_group.WebfrontendSGILS.id]
  #subnets            = module.vpcmodule.websubnet_id

  enable_deletion_protection = false
  tags = {
    Environment = "prod"
  }
}

resource "aws_lb_target_group" "ip_mytg" {
  name        = "tf-mtTG-lb-tg"
  port        = 8080
  protocol    = "HTTP"

  lifecycle {
    ignore_changes = [
      name
    ]
  }
health_check {
  healthy_threshold   =2
  unhealthy_threshold =2
  timeout             =3
  interval            =30
}
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.Application.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip_mytg.arn
  }
}

