variable "location" {
  type        = string
  description = "The Azure location in which the deployment is happening"
  default     = "eastus"
}

variable "resourceSuffix" {
  type        = string
  description = "A suffix for naming"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
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
}

variable "publisherName" {
  description = "The name of the publisher/company"
  type        = string
  default     = "Contoso"
}

variable "publisherEmail" {
  description = "The email of the publisher/company; shows as administrator email in APIM"
  type        = string
  default     = "apim@contoso.com"
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
}

variable "vnetId" {
  description = "The ID of the Virtual Network for DNS zone linking"
  type        = string
}

variable "workspaceId" {
  type        = string
  description = "The workspace id of the log analytics workspace"
}

variable "instrumentationKey" {
  type        = string
  description = "App insights instrumentation key"
}

variable "appInsightsId" {
  type        = string
  description = "The resource ID of the Application Insights instance"
}

variable "sharedResourceGroupName" {
  type        = string
  description = "The name of the shared resource group"
}