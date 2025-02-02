variable "aws_region" {
  type = string
}

variable "application" {
  type = string
}

variable "random_password_config" {
  type = object({
    length           = number
    special          = bool
    override_special = string
  })
}

variable "database_config" {
  type = object({
    engine                          = string
    engine_version                  = string
    instance_class                  = string
    allocated_storage               = number
    storage_type                    = string
    db_master_user                  = string
    db_parameter_group_family       = string
    apply_modifications_immediately = bool
    db_port                         = number
  })
}
