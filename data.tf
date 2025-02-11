#######################
#### VPC E SUBNETS ####
#######################
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.application}-vpc"]
  }
}

data "aws_subnets" "privates" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  tags = {
    Tier = "private"
  }
}

data "aws_subnet" "each_private" {
  for_each = toset(data.aws_subnets.privates.ids)
  id       = each.value
}
