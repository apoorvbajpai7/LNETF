resource "azurerm_resource_group" "lne_rg" {
  name     = "lne"
  location = "East US"
}
 
resource "azurerm_container_registry" "acr" {
  name                = "lneTask"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_resource_group.lne_rg.location
  sku                 = "Standard"
  admin_enabled       = true
}
 
resource "azurerm_service_plan" "react_plan" {
  name                = "reactapp"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_resource_group.lne_rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}
 
resource "azurerm_linux_web_app" "node_app" {
  name                = "node_app"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_service_plan.react_plan.location
  service_plan_id     = azurerm_service_plan.react_plan.id
 
  site_config {
    application_stack {
      docker_image_name = "cubcontainerregistry2.azurecr.io/lne/node-app:1.0"
    }
  }
}
 
 
resource "azurerm_container_group" "react_app" {
  name                = "lne-react-app"
  location            = azurerm_resource_group.lne_rg.location
  resource_group_name = azurerm_resource_group.lne_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "lne"
  os_type             = "Linux"
 
  container {
    name   = "react-app"
    image  = "cubcontainerregistry2.azurecr.io/lne/react-app:1.0"
    cpu    = "0.5"
    memory = "1.5"
 
    ports {
      port     = 80
      protocol = "TCP"
    }
 
    environment_variables = {
      API_BASE_URL= "http://testlne.azurewebsites.net"
    }
  }
 
  image_registry_credential {
    server = "cubcontainerregistry2.azurecr.io"
    username = "user"
    password = "password123"
  }
}
 
 
resource "azurerm_container_group" "node_app" {
  name                = "lne-node-app"
  location            = azurerm_resource_group.lne_rg.location
  resource_group_name = azurerm_resource_group.lne_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "lnenode"
  os_type             = "Linux"
 
  container {
    name   = "react-app"
    image  = "cubcontainerregistry2.azurecr.io/lne/node-app:1.0"
    cpu    = "1"
    memory = "1.5"
 
    ports {
      port     = 80
      protocol = "TCP"
    }
 
    environment_variables = {
        API_BASE_URL= "http://testlne.azurewebsites.net"
        APPLICATION_HOST= "0.0.0.0"
        APPLICATION_PORT="80"
        DBDIALECT="postgres"
        DBHOST="lnepostgres.postgres.database.azure.com"
        DBNAME="sample-appdb"
        DBPASSWORD="Password#123!"
        DBPORT="5432"
        DBUSERNAME="lne2"
        NODE_ENV="production"
        WHITELIST_URLS="http://lne.EastUS.azurecontainer.io"
    }
  }
 
  image_registry_credential {
    server = "cubcontainerregistry2.azurecr.io"
    username = "user"
    password = "password123"
  }
}
 
#####################POSTGRES########################################
resource "azurerm_postgresql_flexible_server" "postgres_flex_server" {
  name                   = "lnepostgres"
  resource_group_name    = azurerm_resource_group.lne_rg.name
  location               = azurerm_resource_group.lne_rg.location
  version                = "16"
  administrator_login    = "db_user"
  administrator_password = "db_password"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = 2
}
 
resource "azurerm_postgresql_flexible_server_database" "sample_db" {
  name      = "sample-appdb"
  server_id = azurerm_postgresql_flexible_server.postgres_flex_server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}