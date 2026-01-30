output "id" {
  description = "Specifies the resource id of the private dns zone"
  value       = azurerm_private_dns_zone.private_dns_zone.id
}

output "name" {
  description = "The name of the private DNS zone"
  value       = azurerm_private_dns_zone.private_dns_zone.name
}

output "vnet_link_id" {
  description = "The ID of the VNet link"
  value       = azurerm_private_dns_zone_virtual_network_link.link.id
}
