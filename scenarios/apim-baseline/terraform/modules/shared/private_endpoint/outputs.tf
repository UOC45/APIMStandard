output "id" {
  description = "Specifies the resource id of the private endpoint."
  value       = azurerm_private_endpoint.private_endpoint.id
}

output "name" {
  description = "The name of the private endpoint"
  value       = azurerm_private_endpoint.private_endpoint.name
}

output "private_ip_address" {
  description = "The private IP address of the private endpoint"
  value       = azurerm_private_endpoint.private_endpoint.private_service_connection[0].private_ip_address
}

output "private_dns_zone_group" {
  description = "Specifies the private dns zone group of the private endpoint."
  value       = azurerm_private_endpoint.private_endpoint.private_dns_zone_group
}

output "private_dns_zone_ids" {
  description = "Specifies the private dns zone IDs linked to the private endpoint"
  value       = try(azurerm_private_endpoint.private_endpoint.private_dns_zone_group[0].private_dns_zone_ids, [])
}
