resource "azurerm_resource_group" "terraform-resource" {
  name     = var.storage_account_name
  location = var.location
  tags     = local.commun_tags
}

resource "azurerm_storage_account" "terraform_storage_account" {
  name                     = "messiasportfolio"
  resource_group_name      = azurerm_resource_group.terraform-resource.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = local.commun_tags
}

resource "azurerm_storage_container" "terraform_storage_container" {
  name                 = "imagens"
  storage_account_name = azurerm_storage_account.terraform_storage_account.name
}