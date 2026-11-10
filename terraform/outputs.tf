output "resource_group_name" {
  description = "Nombre del Resource Group"
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "Nombre del Storage Account"
  value       = azurerm_storage_account.main.name
}

output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = azurerm_virtual_network.main.id
}
