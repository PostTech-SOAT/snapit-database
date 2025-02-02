module "database_security_group" {
  source = "../security_group"

  security_group_name        = "rds-${var.application}"
  security_group_description = "Security group do RDS ${var.application}"
  vpc_id                     = var.vpc_id
  egress                     = var.egress
  ingress                    = var.ingress

}

resource "aws_db_subnet_group" "this" {
  name       = "subnet-group-${var.application}"
  subnet_ids = var.db_subnet_group_ids

  tags = {
    Name = "subnet-group-${var.application}"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-${var.application}"
  family = var.database_config.db_parameter_group_family

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_password" "password" {
  length           = var.random_password_config.length
  special          = var.random_password_config.special
  override_special = var.random_password_config.override_special
}

resource "aws_secretsmanager_secret" "this" {
  name = "sm-rds-${var.application}"

  tags = {
    Name = "sm-rds-${var.application}"
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
   {
    "username": "${var.database_config.db_master_user}",
    "password": "${random_password.password.result}"
   }
  EOF
}

resource "aws_db_instance" "this" {
  identifier             = "${var.application}-db"
  allocated_storage      = var.database_config.allocated_storage
  storage_type           = var.database_config.storage_type
  engine                 = var.database_config.engine
  engine_version         = var.database_config.engine_version
  instance_class         = var.database_config.instance_class
  username               = jsondecode(aws_secretsmanager_secret_version.this.secret_string)["username"]
  password               = jsondecode(aws_secretsmanager_secret_version.this.secret_string)["password"]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [module.database_security_group.security_group_id]
  parameter_group_name   = aws_db_parameter_group.this.name
  apply_immediately      = var.database_config.apply_modifications_immediately
  skip_final_snapshot    = true

  tags = {
    Name = "${var.application}-db"
  }

  depends_on = [
    module.database_security_group,
    aws_db_subnet_group.this,
    aws_db_parameter_group.this,
    aws_secretsmanager_secret_version.this
  ]
}
