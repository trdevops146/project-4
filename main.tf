resource "aws_instance" "new_instance" {
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
}
