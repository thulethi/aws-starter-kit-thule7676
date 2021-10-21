terraform {
  backend "s3" {
    region = "eu-central-1"

    dynamodb_table       = "terraform-locks-CHANGE_ME"
    bucket               = "terraform-state-CHANGE_ME"
    workspace_key_prefix = "envs"
    key                  = "ask-training.tfstate"

    acl     = "bucket-owner-full-control"
    encrypt = true
  }
}
