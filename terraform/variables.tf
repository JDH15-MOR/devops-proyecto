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
