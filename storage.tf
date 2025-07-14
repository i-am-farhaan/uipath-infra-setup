# Azure Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #enable_https_traffic_only = true

  tags = {
    environment = var.environment
  }
}

# Storage Container
resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name
  storage_account_id =   azurerm_storage_account.storage.id
  container_access_type = "private"
}
