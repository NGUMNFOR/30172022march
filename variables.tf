
#data"aws_caller_identity.current" {}#
variable "vpccidr" {
    description = "This is for my vpc cidr"
    type = string
       default = "10.0.0.0/16" 
}

variable "myAppAZ3" {
    description = "This is for my App AZ"
    type = string
    default = "us-east-1c" 
}
variable "WebSG" {
    description = "This is for my security Web SG"
    type = number
    default = 22
}
variable "AppSG" {
    description = "This is for my App SG"
    type = number
    default = 5432  
}


variable "webinstance" {
    description = "This is for my web instance"
    type = string
    default = "ami-06cffe063efe892ad"
  
}
variable "instancetype" {
    description = "my instance type"
    type = string
    default = "t2.micro"
  
}
variable "public_key" {
    description = "This is my key pair"
    type = string
    default =  "C:\\Users\\ngumj\\.ssh\\yes.pub"
} 
variable "websubnetnames" {
    description = "(optional) describe your variable"
    type = list
    default = ["WebsubnetILS1","WebsubnetILS2","CDCsubnet", "websubnet4"] 
}
variable "Appsubnames" {
    description = "(optional) describe your variable"
    type = list
    default = ["APPsubnetILS1","APPsubnetILS2","AppCDCsubnet"]
  
}
