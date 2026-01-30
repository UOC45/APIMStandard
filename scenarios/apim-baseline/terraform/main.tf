# Main deployment for Standard v2 APIM with Private Endpoints

locals {
  resourceSuffix              = "${var.workloadName}-${var.environment}-${var.location}-${var.identifier}"
  networkingResourceGroupName = "rg-networking-${local.resourceSuffix}"
  sharedResourceGroupName     = "rg-shared-${local.resourceSuffix}"
  apimResourceGroupName       = "rg-apim-${local.resourceSuffix}"
  keyVaultName                = "kv-${var.workloadName}-${var.environment}-${var.identifier}"
  tags = {
    Environment = var.environment
    Workload    = var.workloadName
    ManagedBy   = "Terraform"
  }
}

#-------------------------------
# Resource Groups
#-------------------------------
resource "azurerm_resource_group" "networking" {
  name     = local.networkingResourceGroupName
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "shared" {
  name     = local.sharedResourceGroupName
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "apim" {
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
  location                     = var.location
  resourceGroupName            = azurerm_resource_group.networking.name
  resourceSuffix               = local.resourceSuffix
  environment                  = var.environment
  appGatewayAddressPrefix      = var.appGatewayAddressPrefix
  apimCSVNetNameAddressPrefix  = var.apimCSVNetNameAddressPrefix
  privateEndpointAddressPrefix = var.privateEndpointAddressPrefix
  deploymentAddressPrefix      = var.deploymentAddressPrefix
  zones                        = var.zones
}

#-------------------------------
# Shared Resources Module
#-------------------------------
module "shared" {
  depends_on           = [module.networking]
  source               = "./modules/shared"
  location             = var.location
  resourceGroupName    = azurerm_resource_group.shared.name
  resourceSuffix       = local.resourceSuffix
  additionalClientIds  = var.additionalClientIds
  keyVaultName         = local.keyVaultName
  keyVaultSku          = var.keyVaultSku
  deploymentSubnetId   = module.networking.deploymentSubnetId
  storage_account_name = substr(lower(replace("stdep${local.resourceSuffix}", "-", "")), 0, 24)
}

#-------------------------------
# APIM Module - Standard v2 with Private Endpoints
#-------------------------------
module "apim" {
  depends_on                  = [module.shared, module.networking]
  source                      = "./modules/apim"
  location                    = var.location
  resourceGroupName           = azurerm_resource_group.apim.name
  networkingResourceGroupName = azurerm_resource_group.networking.name
  resourceSuffix              = local.resourceSuffix
  environment                 = var.environment
  privateEndpointSubnetId     = module.networking.privateEndpointSubnetId
  vnetId                      = module.networking.vnetId
  instrumentationKey          = module.shared.instrumentationKey
  workspaceId                 = module.shared.workspaceId
  appInsightsId               = module.shared.appInsightsId
  sharedResourceGroupName     = azurerm_resource_group.shared.name
  keyVaultName                = local.keyVaultName
  skuName                     = var.apimSkuName
}

#-------------------------------
# Application Gateway Module
#-------------------------------
module "gateway" {
  depends_on              = [module.networking, module.apim, module.shared]
  source                  = "./modules/gateway"
  location                = var.location
  resourceGroupName       = azurerm_resource_group.networking.name
  resourceSuffix          = local.resourceSuffix
  environment             = var.environment
  appGatewayFqdn          = var.appGatewayFqdn
  appGatewayCertType      = var.appGatewayCertType
  certificate_password    = var.certificatePassword
  certificate_path        = var.certificatePath
  subnetId                = module.networking.appGatewaySubnetId
  # For Standard v2, APIM FQDN resolves via private DNS zone to private endpoint IP
  primaryBackendendFqdn   = module.apim.backendFqdn
  keyvaultId              = module.shared.keyVaultId
  keyVaultName            = module.shared.keyVaultName
  sharedResourceGroupName = azurerm_resource_group.shared.name
  deploymentIdentityName  = module.shared.deploymentIdentityName
  deploymentSubnetId      = module.networking.deploymentSubnetId
  deploymentStorageName   = module.shared.deploymentStorageName
}

# NOTE: No separate DNS module needed for Standard v2 
# The private DNS zone is created by the apim-v2 module

