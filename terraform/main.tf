module "target-node-1" {
  source        = "./module-ec2-ubuntu"
  instance_type = var.instance_type
  key_name      = var.key_name
  instance_role = "backend"

  tags = {
    Name        = "Ubuntu - Backend Target Node"
    Environment = "dev"
    Team        = "mobile-app"
    Type        = "backend"
  }
}

module "target-node-2" {
  source        = "./module-ec2-ubuntu"
  instance_type = var.instance_type
  key_name      = var.key_name
  instance_role = "database"

  tags = {
    Name        = "Ubuntu - Database Target Node"
    Environment = "dev"
    Team        = "mobile-app"
    Type        = "database"
  }
}

output "public_ip_node1" {
  value = module.target-node-1.public_ip
}

output "public_ip_node2" {
  value = module.target-node-2.public_ip
}
