module "rds_postgres" {
  source = "./modules/database"

  application            = var.application
  vpc_id                 = data.aws_vpc.main.id
  db_subnet_group_ids    = data.aws_subnets.privates.ids
  random_password_config = var.random_password_config
  database_config        = var.database_config

  ingress = [{ from_port = "${var.database_config.db_port}", to_port = "${var.database_config.db_port}", protocol = "tcp", cidr_blocks = [for subnet in data.aws_subnet.each_private : subnet.cidr_block] }]
  egress  = [{ from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
}
