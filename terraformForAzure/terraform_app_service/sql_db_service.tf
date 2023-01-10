resource "azurerm_mssql_server" "mssql" {
  name                         = "sqlserverabhi1"
  resource_group_name          = azurerm_resource_group.appservice.name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "abhishek"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "test" {
  name           = "acctest-db-d"
  server_id      = azurerm_mssql_server.mssql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 20
  sku_name       = "S0"
  depends_on = [
    azurerm_mssql_server.mssql
  ]
}

resource "azurerm_mssql_firewall_rule" "mysql" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.mssql.id
  start_ip_address = "4.224.80.60"
  end_ip_address   = "4.224.80.60"
}