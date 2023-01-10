resource "azurerm_windows_web_app_slot" "newslot" {
  name                = "staging"
  app_service_id = azurerm_windows_web_app.windows.id
  

  site_config {
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v7.0"
    }
  }
  depends_on = [
     azurerm_windows_web_app.windows
  ]

}