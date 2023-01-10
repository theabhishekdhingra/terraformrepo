resource "azurerm_service_plan" "appservice" {
  name                = "appservice1"
  location            = local.location
  resource_group_name = azurerm_resource_group.appservice.name
  sku_name = "B1"
  os_type = "Windows"
}

resource "azurerm_windows_web_app" "windows" {
  name                = "windows-plan"
  resource_group_name = azurerm_resource_group.appservice.name
  location            = local.location
  service_plan_id     = azurerm_service_plan.appservice.id
  app_settings        = var.webapp_app_settings
  auth_settings {
    enabled = true 
    unauthenticated_client_action = "RedirectToLoginPage"
    default_provider = "MicrosoftAccount"
    token_store_enabled = true
    
    microsoft {
      client_id = "edfshvas-35ar-3672-7612-ertdbvsvnajs"
      client_secret_setting_name = "abc"
    }
  }

  site_config {
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v7.0"
    }
    ftps_state = "FtpsOnly"
    http2_enabled = true
    minimum_tls_version = "1.2"
}
}