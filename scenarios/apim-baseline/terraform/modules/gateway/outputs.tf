output "gatewayName" {
  value       = azurerm_application_gateway.network.name
  description = "The name of the Application Gateway"
}

output "gatewayId" {
  value       = azurerm_application_gateway.network.id
  description = "The ID of the Application Gateway"
}

output "publicIpAddress" {
  value       = azurerm_public_ip.public_ip.ip_address
  description = "The Public IP address of the Application Gateway"
}
