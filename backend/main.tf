terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "Private_Storage_ME"
    storage_account_name = "messiasportfolio"
    container_name       = "imagens"
    key                  = "vm-portfolios/terraform.tfstate"
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}