output "appGatewaySubnetId" {
  value       = azurerm_subnet.appgateway_subnet.id
  description = "The ID of the Application Gateway subnet"
}

output "privateEndpointSubnetId" {
  value       = azurerm_subnet.private_endpoint_subnet.id
  description = "The ID of the Private Endpoint subnet"
}

output "deploymentSubnetId" {
  value       = azurerm_subnet.deploy_subnet.id
  description = "The ID of the deployment subnet"
}

output "vnetId" {
  value       = azurerm_virtual_network.apim_cs_vnet.id
  description = "The ID of the Virtual Network"
}

output "vnetName" {
  value       = azurerm_virtual_network.apim_cs_vnet.name
  description = "The name of the Virtual Network"
}

