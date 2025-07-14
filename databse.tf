# SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  tags = {
    environment = var.environment
  }
}

# SQL Database
resource "azurerm_mssql_database" "sql_db" {
  name                = var.sql_database_name
  server_id           = azurerm_mssql_server.sql_server.id
  sku_name            = "Basic"
  max_size_gb         = 2
  zone_redundant      = false
  collation           = "SQL_Latin1_General_CP1_CI_AS"

  tags = {
    environment = var.environment
  }
}
