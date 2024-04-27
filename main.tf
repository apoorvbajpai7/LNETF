# main.tf

# Azure provider configuration
provider "azurerm" {
  features {}
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                     = "lneTask"
  resource_group_name      = lne
  location                 = "East US"
  sku                      = "Basic"
}

# Azure App Service
resource "azurerm_app_service" "app_service" {
  name                = "myappservice"
  location            = "East US"
  resource_group_name = lne
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    # App Service configuration
  }
}

# Azure Container Instance
resource "azurerm_container_group" "container_group" {
  name                = "lne"
  location            = "East US"
  resource_group_name = lne

  container {
    name   = "nginx"
    image  = "nginx"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  os_type    = "Linux"
}

# Azure PostgreSQL Flexible Server
resource "azurerm_postgresql_server" "postgres_server" {
  name                = "mypostgresqlserver"
  location            = "East US"
  resource_group_name = lne
  sku_name            = "Standard_D2s_v3"
  storage_profile     = "Standard_LRS"
  version             = "12"
  administrator_login          = "myadmin"
  administrator_login_password = "Password123!"
}
