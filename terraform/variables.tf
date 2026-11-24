variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "staging"
}

variable "location" {
  description = "Region de Azure"
  type        = string
  default     = "eastus"
}

variable "node_count" {
  description = "Numero de nodos"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Tamaño de la máquina virtual de AKS"
  type        = string
  default     = "Standard_b2s_v2"
}
