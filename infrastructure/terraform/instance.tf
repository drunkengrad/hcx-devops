resource "aws_key_pair" "admin-key-pair" {
  key_name   = "admin-key-pair"
  public_key = file("admin-key-pair.pub")
}


resource "aws_instance" "server" {
  for_each      = var.ec2
  ami           = var.ami
  instance_type = each.value
  key_name      = aws_key_pair.admin-key-pair.key_name
  subnet_id     = aws_subnet.private_subnet.id
  tags = {
    Name        = each.key
    Environment = var.env
  }
}
