variable "location" {
  type        = string
  description = "Azure region location"
  default     = "northeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group"
  default     = "jagendra-infra-bootcamp"
}

variable "workspace_name" {
  type        = string
  description = "Workspace name"
  default     = "aks-log-workspace"
}

variable "keyvault_name" {
  type        = string
  description = "keyvault name"
  default     = "aks-keyvault-jag"
}

variable "postgress_name" {
  type        = string
  description = "postgress name"
  default     = "aks-postgres-server"
}

variable "postgress_db_name" {
  type        = string
  description = "postgress db name"
  default     = "exampledb"
}

variable "name" {
  type        = string
  description = "cluster or dns name"
  default     = "aks-cluster"
}

variable "vm_size" {
  type        = string
  description = "vm size"
  default     = "Standard_D4s_v3"
}


