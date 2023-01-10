locals {
  location = "North Europe"
  resource-grp-name = "appservice"
}


resource "azurerm_resource_group" "appservice" {
  name = local.resource-grp-name
  location = local.location
}


