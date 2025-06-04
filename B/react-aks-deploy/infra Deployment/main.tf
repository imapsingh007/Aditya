

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "reactaksdns"

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}










resource "azurerm_mssql_server" "sql_server" {
  name                         = "pytododbsqlserver"
  resource_group_name          = azurerm_resource_group.main.name
  location                     =  "West Europe"
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "YourP@ssword1234!"
}

resource "azurerm_mssql_database" "sql_db" {
  name                = "pytododatabase"
  server_id           = azurerm_mssql_server.sql_server.id
  sku_name            = "Basic"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 2
}

resource "azurerm_mssql_firewall_rule" "allow_all" {
  name             = "AllowAll"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
