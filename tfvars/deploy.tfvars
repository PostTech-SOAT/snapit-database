##############################################################################
#                      GENERAL                                               #
##############################################################################

application = "snapit"
aws_region  = "us-east-1"

##############################################################################
#                      DATABASE                                              #
##############################################################################

database_config = {
  engine                          = "postgres"
  engine_version                  = "16.3"
  instance_class                  = "db.t4g.micro"
  allocated_storage               = 20
  storage_type                    = "gp3"
  db_master_user                  = "snapitadmin"
  db_parameter_group_family       = "postgres16"
  apply_modifications_immediately = true
  db_port                         = 5432
}

random_password_config = {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
