variable "location" {
  type        = string
  description = "The Azure location in which the deployment is happening"
  default     = "eastus"
}

variable "resourceSuffix" {
  type        = string
  description = "A suffix for naming"
}

variable "resourceGroupName" {
  type        = string
  description = "The name of the resource group"
}

variable "networkingResourceGroupName" {
  type        = string
  description = "The name of the networking resource group"
}

#-------------------------------
# APIM specific variables
#-------------------------------

variable "keyVaultName" {
  description = "The name of the Key Vault"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.keyVaultName))
    error_message = "The keyVaultName must be between 3 and 24 characters and contain only alphanumerics and hyphens."
  }
}

variable "publisherName" {
  description = "The name of the publisher/company"
  type        = string
  default     = "Contoso"

  validation {
    condition     = length(var.publisherName) > 0
    error_message = "The publisherName cannot be empty."
  }
}

variable "publisherEmail" {
  description = "The email of the publisher/company; shows as administrator email in APIM"
  type        = string
  default     = "apim@contoso.com"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.publisherEmail))
    error_message = "The publisherEmail must be a valid email address."
  }
}

variable "skuName" {
  description = "The SKU name for Standard v2 APIM. Valid values: StandardV2_1, BasicV2_1"
  type        = string
  default     = "StandardV2_1"

  validation {
    condition     = can(regex("^(StandardV2|BasicV2)_[0-9]+$", var.skuName))
    error_message = "The skuName must be in format StandardV2_X or BasicV2_X where X is the capacity."
  }
}

variable "privateEndpointSubnetId" {
  description = "The subnet id for the APIM private endpoint"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+/subnets/[^/]+$", var.privateEndpointSubnetId))
    error_message = "The privateEndpointSubnetId must be a valid Azure Subnet ID."
  }
}

variable "appInsightsConnectionString" {
  type        = string
  description = "App Insights connection string (preferred over instrumentation key)"
  sensitive   = true
  default     = ""
}

# Deprecated: Use appInsightsConnectionString instead
variable "instrumentationKey" {
  type        = string
  description = "App insights instrumentation key (deprecated - use appInsightsConnectionString)"
  sensitive   = true

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.instrumentationKey))
    error_message = "The instrumentationKey must be a valid GUID."
  }
}

variable "appInsightsId" {
  type        = string
  description = "The resource ID of the Application Insights instance"

  validation {
    condition     = startswith(var.appInsightsId, "/subscriptions/")
    error_message = "The appInsightsId must be a valid Azure Resource ID."
  }
}

variable "sharedResourceGroupName" {
  type        = string
  description = "The name of the shared resource group"
}