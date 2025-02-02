remote_state {
    backend = "s3"
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite"
    }
    config = {
        bucket         = "snapit-tfstate"
        key            = "database/database.tfstate"
        region         = "us-east-1"
        encrypt        = true
        dynamodb_table = "snapit-tfstate-lock"
    }
}

terraform {
  source = "../"

  extra_arguments "conditional_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
      "import",
      "push",
      "refresh",
      "import"
    ]

    required_var_files = [
      "./tfvars/deploy.tfvars"
    ]
  }
}