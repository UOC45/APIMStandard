# APIM Standard v2 with Private Endpoints
# Standard v2 does NOT support VNet injection - uses private endpoints instead

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.1"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
    }
  }
}

locals {
  apimName         = "apim-${var.resourceSuffix}"
  apimIdentityName = "identity-${local.apimName}"
}

#-------------------------------
# User Assigned Identity for APIM
#-------------------------------
resource "azurerm_user_assigned_identity" "apimIdentity" {
  name                = local.apimIdentityName
  location            = var.location
  resource_group_name = var.resourceGroupName
}

data "azurerm_key_vault" "keyVault" {
  name                = var.keyVaultName
  resource_group_name = var.sharedResourceGroupName
}

#-------------------------------
# Standard v2 APIM - No VNet injection, uses private endpoints
#-------------------------------
resource "azurerm_api_management" "apim_v2" {
  name                = local.apimName
  location            = var.location
  resource_group_name = var.resourceGroupName
  publisher_name      = var.publisherName
  publisher_email     = var.publisherEmail

  # Standard v2 SKU - does NOT support virtual_network_type
  sku_name = var.skuName

  # Must be enabled during creation, will be disabled via azapi after private endpoint is configured
  public_network_access_enabled = true

  min_api_version = "2019-12-01"

  # NOTE: No virtual_network_configuration block for Standard v2
  # Network isolation is achieved via private endpoints

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.apimIdentity.id]
  }

  lifecycle {
    ignore_changes = [public_network_access_enabled]
  }
}

#-------------------------------
# Private DNS Zone for APIM
#-------------------------------
resource "azurerm_private_dns_zone" "apim_dns_zone" {
  name                = "privatelink.azure-api.net"
  resource_group_name = var.networkingResourceGroupName

  lifecycle {
    #prevent_destroy = true
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "apim_dns_vnet_link" {
  name                  = "apim-dns-vnet-link"
  resource_group_name   = var.networkingResourceGroupName
  private_dns_zone_name = azurerm_private_dns_zone.apim_dns_zone.name
  virtual_network_id    = var.vnetId
  registration_enabled  = false

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Private Endpoint for APIM Gateway
#-------------------------------
resource "azurerm_private_endpoint" "apim_gateway_pe" {
  name                = "pep-${local.apimName}-gateway"
  location            = var.location
  resource_group_name = var.networkingResourceGroupName
  subnet_id           = var.privateEndpointSubnetId

  private_service_connection {
    name                           = "apim-gateway-privateserviceconnection"
    private_connection_resource_id = azurerm_api_management.apim_v2.id
    subresource_names              = ["Gateway"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "apim-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.apim_dns_zone.id]
  }

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# NOTE: Public network access remains enabled during deployment.
# APIM Standard V2 does not support disabling public access during creation.
# Traffic is secured via Application Gateway + Private Endpoint.
# To disable public access after deployment, run:
#   az apim update --name <apim-name> --resource-group <rg-name> --public-network-access false
#-------------------------------

#-------------------------------
# APIM Logger for Application Insights
#-------------------------------
resource "azurerm_api_management_logger" "apim_logger" {
  name                = "apim-logger"
  api_management_name = azurerm_api_management.apim_v2.name
  resource_group_name = var.resourceGroupName
  resource_id         = var.appInsightsId

  application_insights {
    instrumentation_key = var.instrumentationKey
  }

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# API Management Service Diagnostic
#-------------------------------
resource "azurerm_api_management_diagnostic" "apim_diagnostic" {
  identifier               = "applicationinsights"
  resource_group_name      = var.resourceGroupName
  api_management_name      = azurerm_api_management.apim_v2.name
  api_management_logger_id = azurerm_api_management_logger.apim_logger.id

  sampling_percentage = 100.0
  always_log_errors   = true
  verbosity           = "verbose"

  frontend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  frontend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }

  backend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  backend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Starter Product
#-------------------------------
resource "azurerm_api_management_product" "starter" {
  display_name          = "Starter"
  product_id            = "starter"
  api_management_name   = azurerm_api_management.apim_v2.name
  resource_group_name   = azurerm_api_management.apim_v2.resource_group_name
  published             = true
  subscription_required = true
  approval_required     = false

  lifecycle {
    #prevent_destroy = true
  }
}

resource "random_uuid" "starter_key" {
  lifecycle {
    #prevent_destroy = true
  }
}

resource "azurerm_api_management_subscription" "echo" {
  api_management_name = azurerm_api_management.apim_v2.name
  resource_group_name = azurerm_api_management.apim_v2.resource_group_name
  product_id          = azurerm_api_management_product.starter.id
  display_name        = "Echo API"
  primary_key         = random_uuid.starter_key.result
  allow_tracing       = false
  state               = "active"

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Echo API
#-------------------------------
resource "azurerm_api_management_api" "echo_api" {
  name                = "echo-api"
  api_management_name = azurerm_api_management.apim_v2.name
  resource_group_name = azurerm_api_management.apim_v2.resource_group_name
  revision            = "1"
  display_name        = "Echo API"
  path                = "echo"
  protocols           = ["https"]
  service_url         = "https://httpbin.io/anything"

  lifecycle {
    #prevent_destroy = true
  }
}

resource "azurerm_api_management_api_operation" "echo_api_operation" {
  api_name            = azurerm_api_management_api.echo_api.name
  api_management_name = azurerm_api_management.apim_v2.name
  resource_group_name = azurerm_api_management.apim_v2.resource_group_name
  display_name        = "Retrieve resource"
  method              = "GET"
  url_template        = "/resource"

  request {
    query_parameter {
      type          = "string"
      name          = "param1"
      default_value = "sample"
      required      = true
    }
    query_parameter {
      type     = "number"
      name     = "param2"
      required = false
    }
  }

  response {
    status_code = 200
    description = "A demonstration of a GET call on a sample resource."
  }
  operation_id = "retrieve-resource"

  lifecycle {
    #prevent_destroy = true
  }
}

resource "azurerm_api_management_product_api" "echo" {
  api_name            = azurerm_api_management_api.echo_api.name
  product_id          = azurerm_api_management_product.starter.product_id
  api_management_name = azurerm_api_management.apim_v2.name
  resource_group_name = azurerm_api_management.apim_v2.resource_group_name

  lifecycle {
    #prevent_destroy = true
  }
}

#-------------------------------
# Key Vault Access Policy for APIM
#-------------------------------
resource "azurerm_key_vault_access_policy" "apim_access_policy" {
  key_vault_id = data.azurerm_key_vault.keyVault.id
  tenant_id    = azurerm_user_assigned_identity.apimIdentity.tenant_id
  object_id    = azurerm_user_assigned_identity.apimIdentity.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]
}