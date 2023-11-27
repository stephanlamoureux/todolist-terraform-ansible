resource "aws_instance" "ubuntu_node" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.instance_role == "backend" ? aws_security_group.backend_security_group.name : aws_security_group.database_security_group.name]
  tags            = var.tags
}

