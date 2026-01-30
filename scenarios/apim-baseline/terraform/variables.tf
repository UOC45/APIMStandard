variable "location" {
  type        = string
  description = "The Azure location in which the deployment is happening"
  default     = "eastus2"
}

variable "workloadName" {
  type        = string
  description = "A suffix for naming"
  default     = "apimv2"
}

variable "appGatewayFqdn" {
  type        = string
  description = "The FQDN for the Application Gateway"
  default     = "apim.example.com"
}

variable "appGatewayCertType" {
  type        = string
  description = "selfsigned or custom certificate type"
  default     = "selfsigned"

  validation {
    condition     = contains(["selfsigned", "custom"], var.appGatewayCertType)
    error_message = "appGatewayCertType must be either 'selfsigned' or 'custom'."
  }
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "keyVaultSku" {
  type        = string
  description = "The SKU for Key Vault"
  default     = "standard"
}

variable "additionalClientIds" {
  description = "List of additional clients to add to the Key Vault access policy."
  type        = list(string)
  default     = []
}

variable "certificatePassword" {
  description = "Password for the certificate"
  type        = string
  sensitive   = true
  default     = ""
}

variable "certificatePath" {
  description = "Path to the certificate"
  type        = string
  default     = "../../certs/appgw.pfx"
}

variable "identifier" {
  description = "The identifier for the resource deployments"
  type        = string
}

# Network Variables

variable "apimCSVNetNameAddressPrefix" {
  description = "VNet Address Prefix"
  type        = string
  default     = "10.2.0.0/16"
}

variable "appGatewayAddressPrefix" {
  description = "App Gateway Subnet Address Prefix"
  type        = string
  default     = "10.2.4.0/24"
}

variable "privateEndpointAddressPrefix" {
  description = "Private Endpoint Subnet Address Prefix"
  type        = string
  default     = "10.2.5.0/24"
}

variable "deploymentAddressPrefix" {
  description = "Deployment Subnet Address Prefix"
  type        = string
  default     = "10.2.8.0/24"
}

variable "zones" {
  description = "Availability zones for zone-redundant resources (e.g., Public IP). Use empty list for regions without zone support."
  type        = list(string)
  default     = ["1", "2", "3"]
}

# APIM Standard v2 Variables

variable "apimSkuName" {
  description = "The SKU name for Standard v2 APIM (e.g., StandardV2_1, BasicV2_1)"
  type        = string
  default     = "StandardV2_1"

  validation {
    condition     = can(regex("^(StandardV2|BasicV2)_[0-9]+$", var.apimSkuName))
    error_message = "apimSkuName must be in format 'StandardV2_X' or 'BasicV2_X' where X is the capacity (e.g., StandardV2_1, BasicV2_1)."
  }
}

variable "subscription_id" {
  description = "The Azure subscription ID for the deployment"
  type        = string
}

variable "enableTelemetry" {
  description = "Enable telemetry for the deployment"
  type        = bool
  default     = true
}