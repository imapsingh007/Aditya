variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "react-aks-rg"
}

variable "acr_name" {
  description = "Must be globally unique and lowercase only"
  default     = "reactacr123456"
}

variable "aks_cluster_name" {
  default = "react-aks"
}

variable "node_count" {
  default = 1
}

variable "kubernetes_version" {
  default = "1.31.8"
}

