
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.14"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatedevops6a881a37"
    container_name       = "tfstate"
    key                  = "devops-academia.tfstate"

    use_cli = false
  }
}

provider "azurerm" {
  features {}
}
