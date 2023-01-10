

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.37.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "2ab02db9-94eb-45c2-bcf5-ea9cca5b1a54"
  tenant_id= "881b6799-c60b-4fe1-a8c5-9a1def9648e9"
  client_id = "d114a53c-ff1e-4cb5-809d-0cfd2162f983"
  client_secret = "nX78Q~4p4Yrs-ESlUXpErwAoRRUvveBL45UvHb3q"
  features {
  }
}