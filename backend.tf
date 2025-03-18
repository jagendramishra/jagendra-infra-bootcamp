terraform {
  backend "azurerm" {
    resource_group_name  = "jagendra-infra-bootcamp"
    storage_account_name = "tfstateaksstoragejag"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
