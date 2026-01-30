output "gatewayUrl" {
  value       = azurerm_api_management.apim_v2.gateway_url
  description = "The Gateway URL of the APIM instance"
}

output "backendFqdn" {
  value       = "${azurerm_api_management.apim_v2.name}.azure-api.net"
  description = "The FQDN of the APIM backend"
}

output "subscriptionKey" {
  value       = random_uuid.starter_key.result
  description = "The subscription key for the Echo API"
  sensitive   = true
}

output "apimName" {
  value       = azurerm_api_management.apim_v2.name
  description = "The name of the APIM instance"
}

output "apimIdentityName" {
  value       = azurerm_user_assigned_identity.apimIdentity.name
  description = "The name of the APIM managed identity"
}

output "apimResourceId" {
  value       = azurerm_api_management.apim_v2.id
  description = "The resource ID of the APIM instance"
}

output "privateEndpointId" {
  value       = azurerm_private_endpoint.apim_gateway_pe.id
  description = "The ID of the APIM private endpoint"
}

output "privateEndpointIp" {
  value       = azurerm_private_endpoint.apim_gateway_pe.private_service_connection[0].private_ip_address
  description = "The private IP address of the APIM gateway endpoint"
}

output "privateDnsZoneId" {
  value       = azurerm_private_dns_zone.apim_dns_zone.id
  description = "The ID of the private DNS zone"
}

output "apimIdentityPrincipalId" {
  value       = azurerm_user_assigned_identity.apimIdentity.principal_id
  description = "The principal ID of the APIM managed identity"
}