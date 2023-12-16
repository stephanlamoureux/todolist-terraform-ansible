resource "aws_instance" "ubuntu_node" {
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.instance_role == "backend" ? aws_security_group.backend_security_group.name : aws_security_group.database_security_group.name]
  tags            = var.tags

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ${path.module}/../${var.instance_role}_ip.txt"
  }
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's owner ID
}

output "instance_id" {
  value = aws_instance.ubuntu_node.id
}
