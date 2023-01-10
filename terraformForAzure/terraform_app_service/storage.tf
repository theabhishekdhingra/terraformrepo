resource "azurerm_storage_account" "storageacc" {
  name                     = "appstorage04012023"
  resource_group_name      = azurerm_resource_group.appservice.name
  location                 = azurerm_resource_group.appservice.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
}

resource "azurerm_storage_container" "logs" {
  name                  = "logs"
  storage_account_name  = azurerm_storage_account.storageacc.name
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.storageacc
  ]
}

data "azurerm_storage_account_blob_container_sas" "example" {
  connection_string = azurerm_storage_account.storageacc.primary_connection_string
  container_name    = azurerm_storage_container.logs.name
  https_only        = true

  start  = "2023-01-01"
  expiry = "2023-03-31"

  permissions {
    read   = true
    add    = true
    create = false
    write  = false
    delete = true
    list   = true
  }

 depends_on = [
   azurerm_storage_container.logs
 ]
}

output "sas_url_query_string" {
  value = nonsensitive("https://${azurerm_storage_account.storageacc.name}.blob.core.windows.net/${azurerm_storage_container.logs.name}${data.azurerm_storage_account_blob_container_sas.example.sas}")
}