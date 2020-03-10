provider "aws" {
  region                  = "us-east-2"
  profile                 = "terraform-user"
}

resource "aws_instance" "example" {
  ami           = "ami-001bc718adff0d598"
  instance_type = "t2.micro"
  security_groups = ["sg-078c81d4c91111dc9"]
  subnet_id = "subnet-03dfc6b9f76832d1f"
  key_name = "server_key"
}