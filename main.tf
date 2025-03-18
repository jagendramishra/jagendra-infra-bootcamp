
provider "azurerm" {
  features {}
  subscription_id = "20eb6d41-18d7-4168-a448-d4e413dde891"
}

resource "azurerm_log_analytics_workspace" "aks_log" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
}

resource "azurerm_key_vault" "kv" {
  name                = var.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = "a39a1414-df49-4d53-96ec-6002b13e0cfb"
}

resource "random_password" "postgres_password" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "postgres_secret" {
  name         = "postgres-password-jag"
  value        = random_password.postgres_password.result
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_postgresql_server" "postgres" {
  name                = var.postgress_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name              = "B_Gen5_2"
  storage_mb            = 5120
  backup_retention_days = 7
  administrator_login   = "adminuser"

  # Fetch password from Key Vault
  administrator_login_password = azurerm_key_vault_secret.postgres_secret.value

  version                 = "11"
  ssl_enforcement_enabled = true
}

resource "azurerm_postgresql_database" "example" {
  name                = var.postgress_db_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }
}
#TBD auto-scalling enablement
resource "azurerm_kubernetes_cluster_node_pool" "example" {
  name                  = "defaultjag"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.vm_size

  min_count = null
  max_count = null
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics" {
  name                       = "aks-diagnostics-jag"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_log.id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}



