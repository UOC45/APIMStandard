output "resourceSuffix" {
  description = "The resource suffix used for naming resources"
  value       = local.resourceSuffix
}

output "networkingResourceGroupName" {
  description = "The name of the networking resource group"
  value       = local.networkingResourceGroupName
}

output "sharedResourceGroupName" {
  description = "The name of the shared resources resource group"
  value       = local.sharedResourceGroupName
}

output "apimResourceGroupName" {
  description = "The name of the APIM resource group"
  value       = local.apimResourceGroupName
}

output "apimName" {
  description = "The name of the API Management instance"
  value       = module.apim.apimName
}

output "apimIdentityName" {
  description = "The name of the APIM managed identity"
  value       = module.apim.apimIdentityName
}

output "apimIdentityPrincipalId" {
  description = "The principal ID of the APIM managed identity"
  value       = module.apim.apimIdentityPrincipalId
}

output "vnetId" {
  description = "The ID of the Virtual Network"
  value       = module.networking.vnetId
}

output "vnetName" {
  description = "The name of the Virtual Network"
  value       = module.networking.vnetName
}

output "privateEndpointSubnetId" {
  description = "The ID of the private endpoint subnet"
  value       = module.networking.privateEndpointSubnetId
}

output "privateEndpointIp" {
  description = "The private IP address of the APIM gateway endpoint"
  value       = module.apim.privateEndpointIp
}

output "keyVaultName" {
  description = "The name of the Key Vault"
  value       = module.shared.keyVaultName
}

output "appGatewayPublicIpAddress" {
  description = "The public IP address of the Application Gateway"
  value       = module.gateway.publicIpAddress
}

output "subscriptionKey" {
  description = "The subscription key for the Echo API"
  value       = module.apim.subscriptionKey
  sensitive   = true
}

output "testCommand" {
  description = "A curl command to test the deployment"
  value       = "curl -k -H \"Ocp-Apim-Subscription-Key: <subscription-key>\" https://${var.app_gateway_fqdn}/echo/resource?param1=sample --resolve ${var.app_gateway_fqdn}:443:${module.gateway.publicIpAddress}"
}