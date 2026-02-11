# Refactored networking for Standard v2 APIM with Private Endpoints
# Standard v2 doesn't require VNet injection - uses private endpoints instead

locals {
  apim_cs_vnet_name            = "vnet-apim-cs-${var.resourceSuffix}"
  appgateway_subnet_name       = "snet-apgw-${var.resourceSuffix}"
  deploy_subnet_name           = "snet-deploy-${var.resourceSuffix}"
  appgateway_snnsg             = "nsg-apgw-${var.resourceSuffix}"
  private_endpoint_subnet_name = "snet-prep-${var.resourceSuffix}"
  private_endpoint_snnsg       = "nsg-prep-${var.resourceSuffix}"
  owner                        = "APIM Const Set"
  appgateway_public_ipname     = "pip-appgw-${var.resourceSuffix}"
}

#-------------------------------
# Application Gateway NSG
#-------------------------------
resource "azurerm_network_security_group" "appgateway_nsg" {
  name                = local.appgateway_snnsg
  location            = var.location
  resource_group_name = var.resourceGroupName

  security_rule {
    name                       = "AllowHealthProbesInbound"
    priority                   = 100
    protocol                   = "*"
    destination_port_range     = "65200-65535"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowTLSInbound"
    priority                   = 110
    protocol                   = "Tcp"
    destination_port_range     = "443"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 111
    protocol                   = "Tcp"
    destination_port_range     = "80"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 121
    protocol                   = "Tcp"
    destination_port_range     = "*"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  # Allow outbound to private endpoints for APIM traffic
  security_rule {
    name                       = "AllowOutboundToPrivateEndpoints"
    priority                   = 200
    protocol                   = "Tcp"
    destination_port_range     = "443"
    access                     = "Allow"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = var.appGatewayAddressPrefix
    destination_address_prefix = var.privateEndpointAddressPrefix
  }

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Private Endpoint Subnet NSG - allows traffic from App Gateway and VNet
#-------------------------------
resource "azurerm_network_security_group" "private_endpoint_nsg" {
  name                = local.private_endpoint_snnsg
  location            = var.location
  resource_group_name = var.resourceGroupName

  security_rule {
    name                       = "AllowHttpsFromAppGateway"
    priority                   = 100
    protocol                   = "Tcp"
    destination_port_range     = "443"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = var.appGatewayAddressPrefix
    destination_address_prefix = var.privateEndpointAddressPrefix
  }

  security_rule {
    name                       = "AllowHttpsFromVNet"
    priority                   = 110
    protocol                   = "Tcp"
    destination_port_range     = "443"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = var.privateEndpointAddressPrefix
  }

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Virtual Network
# NOTE: For Standard v2, we remove the dedicated APIM subnet since it uses private endpoints
#-------------------------------
resource "azurerm_virtual_network" "apim_cs_vnet" {
  name                = local.apim_cs_vnet_name
  location            = var.location
  resource_group_name = var.resourceGroupName
  address_space       = [var.apimCSVNetNameAddressPrefix]

  tags = {
    Owner = local.owner
  }

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Application Gateway Subnet
#-------------------------------
resource "azurerm_subnet" "appgateway_subnet" {
  name                 = local.appgateway_subnet_name
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.apim_cs_vnet.name
  address_prefixes     = [var.appGatewayAddressPrefix]

  lifecycle {
    #prevent_destroy = true
  }
}

resource "azurerm_subnet_network_security_group_association" "appgateway_subnet" {
  subnet_id                 = azurerm_subnet.appgateway_subnet.id
  network_security_group_id = azurerm_network_security_group.appgateway_nsg.id

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Private Endpoint Subnet - used for APIM private endpoint and other services
#-------------------------------
resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = local.private_endpoint_subnet_name
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.apim_cs_vnet.name
  address_prefixes     = [var.privateEndpointAddressPrefix]

  # Required for private endpoints
  private_endpoint_network_policies = "Disabled"

  lifecycle {
    #prevent_destroy = true
  }
}

resource "azurerm_subnet_network_security_group_association" "private_endpoint_subnet" {
  subnet_id                 = azurerm_subnet.private_endpoint_subnet.id
  network_security_group_id = azurerm_network_security_group.private_endpoint_nsg.id

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Deployment Subnet (for certificate generation via container instances)
#-------------------------------
resource "azurerm_subnet" "deploy_subnet" {
  name                 = local.deploy_subnet_name
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.apim_cs_vnet.name
  address_prefixes     = [var.deploymentAddressPrefix]

  service_endpoints = ["Microsoft.Storage"]

  delegation {
    name = "Microsoft.ContainerInstance.containerGroups"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  lifecycle {
    #prevent_destroy = true
  }
}

