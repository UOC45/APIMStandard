output "gatewayUrl" {
  value       = azurerm_api_management.apim_v2.gateway_url
  description = "The Gateway URL of the APIM instance"
}

output "apimPublicFqdn" {
  value       = "${azurerm_api_management.apim_v2.name}.azure-api.net"
  description = "The public FQDN of the APIM instance (internet-exposed). For private endpoint access from within the VNet, use apimPrivateFqdn instead."
}

output "apimPrivateFqdn" {
  value       = "${azurerm_api_management.apim_v2.name}.privatelink.azure-api.net"
  description = "The private FQDN of the APIM instance (resolved via private DNS zone). Use this for connections from within the VNet."
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



output "apimIdentityPrincipalId" {
  value       = azurerm_user_assigned_identity.apimIdentity.principal_id
  description = "The principal ID of the APIM managed identity"
}

output "apimIdentityClientId" {
  value       = azurerm_user_assigned_identity.apimIdentity.client_id
  description = "The client ID of the APIM managed identity"
}

output "managementApiUrl" {
  value       = "https://${azurerm_api_management.apim_v2.name}.management.azure-api.net"
  description = "The management API URL for programmatic management of APIM (requires authentication). Use public URL from here or manage via private endpoint from within VNet."
}

output "developerPortalUrl" {
  value       = "https://${azurerm_api_management.apim_v2.name}.developer.azure-api.net"
  description = "The developer portal URL for API consumers to view and test published APIs. Access is controlled by subscription policies."
}