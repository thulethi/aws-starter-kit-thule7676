terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = "~> 3.0"

    sops = {
      source  = "carlpett/sops"
      version = "0.5.2"
    }
  }
}
