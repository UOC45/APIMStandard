# Main deployment for Standard v2 APIM with Private Endpoints

locals {
  resourceSuffix              = "${var.workload_name}-${var.environment}-${var.location}-${var.identifier}"
  networkingResourceGroupName = "rg-networking-${local.resourceSuffix}"
  sharedResourceGroupName     = "rg-shared-${local.resourceSuffix}"
  apimResourceGroupName       = "rg-apim-${local.resourceSuffix}"
  keyVaultName                = "kv-${var.workload_name}-${var.environment}-${var.identifier}"
  tags = {
    Environment = var.environment
    Workload    = var.workload_name
    ManagedBy   = "Terraform"
  }
}

#-------------------------------
# Resource Groups
#-------------------------------
resource "azurerm_resource_group" "networking" {
  provider = azurerm.networking
  name     = local.networkingResourceGroupName
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "shared" {
  provider = azurerm.shared
  name     = local.sharedResourceGroupName
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "apim" {
  provider = azurerm.apim
  name     = local.apimResourceGroupName
  location = var.location
  tags     = local.tags
}

#-------------------------------
# Networking Module - Standard v2 version (no APIM subnet)
#-------------------------------
module "networking" {
  depends_on                   = [azurerm_resource_group.networking]
  source                       = "./modules/networking"
  providers = {
    azurerm = azurerm.networking
  }
  location                     = var.location
  resourceGroupName            = azurerm_resource_group.networking.name
  resourceSuffix               = local.resourceSuffix
  environment                  = var.environment
  appGatewayAddressPrefix      = var.app_gateway_address_prefix
  apimCSVNetNameAddressPrefix  = var.apim_vnet_address_prefix
  privateEndpointAddressPrefix = var.private_endpoint_address_prefix
  deploymentAddressPrefix      = var.deployment_address_prefix
  zones                        = var.zones
}

#-------------------------------
# Shared Resources Module
#-------------------------------
module "shared" {
  depends_on           = [module.networking]
  source               = "./modules/shared"
  providers = {
    azurerm = azurerm.shared
  }
  location             = var.location
  resourceGroupName    = azurerm_resource_group.shared.name
  resourceSuffix       = local.resourceSuffix
  additionalClientIds  = var.additional_client_ids
  keyVaultName         = local.keyVaultName
  keyVaultSku          = var.key_vault_sku
  deploymentSubnetId   = module.networking.deploymentSubnetId
  storage_account_name = substr(lower(replace("stdep${local.resourceSuffix}", "-", "")), 0, 24)
  tags                 = local.tags
}

#-------------------------------
# DNS Zone for APIM (using generic shared module)
#-------------------------------
module "apim_dns_zone" {
  depends_on                  = [azurerm_resource_group.networking, module.networking]
  source                      = "./modules/shared/private_dns_zone"
  name                        = "privatelink.azure-api.net"
  resource_group_name         = azurerm_resource_group.networking.name
  virtual_networks_to_link_id = module.networking.vnetId
  tags                        = local.tags
}

#-------------------------------
# APIM Module - Standard v2 with Private Endpoints
#-------------------------------
module "apim" {
  depends_on                  = [module.shared, module.networking, module.apim_dns_zone]
  source                      = "./modules/apim"
  providers = {
    azurerm = azurerm.apim
  }
  location                    = var.location
  resourceGroupName           = azurerm_resource_group.apim.name
  networkingResourceGroupName = azurerm_resource_group.networking.name
  resourceSuffix              = local.resourceSuffix
  privateEndpointSubnetId     = module.networking.privateEndpointSubnetId
  instrumentationKey          = module.shared.instrumentationKey
  appInsightsConnectionString = module.shared.appInsightsConnectionString
  appInsightsId               = module.shared.appInsightsId
  sharedResourceGroupName     = azurerm_resource_group.shared.name
  keyVaultName                = local.keyVaultName
  skuName                     = var.apim_sku_name
}

#-------------------------------
# Application Gateway Module
#-------------------------------
module "gateway" {
  depends_on              = [module.networking, module.apim, module.shared, module.apim_dns_zone]
  source                  = "./modules/gateway"
  providers = {
    azurerm = azurerm.networking
  }
  location                = var.location
  resourceGroupName       = azurerm_resource_group.networking.name
  resourceSuffix          = local.resourceSuffix
  appGatewayFqdn          = var.app_gateway_fqdn
  appGatewayCertType      = var.app_gateway_cert_type
  certificate_password    = var.certificate_password
  certificate_path        = var.certificate_path
  subnetId                = module.networking.appGatewaySubnetId
  # For Standard v2, APIM FQDN resolves via private DNS zone to private endpoint IP
  primaryBackendFqdn      = module.apim.apimPrivateFqdn
  keyvaultId              = module.shared.keyVaultId
}

