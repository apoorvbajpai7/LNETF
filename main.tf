// main.tf
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "East US"
}

// Define other Azure resources here (e.g., Azure Container Registry, App Service, etc.)
