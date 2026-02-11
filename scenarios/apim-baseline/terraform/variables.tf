variable "location" {
  type        = string
  description = "The Azure location in which the deployment is happening"
  default     = "eastus2"
}

variable "workload_name" {
  type        = string
  description = "A suffix for naming"
  default     = "apimv2"
}

variable "app_gateway_fqdn" {
  type        = string
  description = "The FQDN for the Application Gateway"
  default     = "apim.example.com"
}

variable "app_gateway_cert_type" {
  type        = string
  description = "selfsigned or custom certificate type"
  default     = "selfsigned"

  validation {
    condition     = contains(["selfsigned", "custom"], var.app_gateway_cert_type)
    error_message = "app_gateway_cert_type must be either 'selfsigned' or 'custom'."
  }
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "key_vault_sku" {
  type        = string
  description = "The SKU for Key Vault"
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "key_vault_sku must be either 'standard' or 'premium'."
  }
}

variable "additional_client_ids" {
  description = "List of additional clients to add to the Key Vault access policy."
  type        = list(string)
  default     = []
}

variable "certificate_password" {
  description = "Password for the certificate"
  type        = string
  sensitive   = true
  default     = ""
}

variable "certificate_path" {
  description = "Path to the certificate"
  type        = string
  default     = "../../certs/appgw.pfx"
}

variable "identifier" {
  description = "The identifier for the resource deployments"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.identifier))
    error_message = "Identifier must be lowercase alphanumeric and between 2-10 characters to satisfy Storage Account naming limits."
  }
}

# Network Variables

variable "apim_vnet_address_prefix" {
  description = "VNet Address Prefix"
  type        = string
  default     = "10.2.0.0/16"
}

variable "app_gateway_address_prefix" {
  description = "App Gateway Subnet Address Prefix"
  type        = string
  default     = "10.2.4.0/24"
}

variable "private_endpoint_address_prefix" {
  description = "Private Endpoint Subnet Address Prefix"
  type        = string
  default     = "10.2.5.0/24"
}

variable "deployment_address_prefix" {
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

variable "apim_sku_name" {
  description = "The SKU name for Standard v2 APIM (e.g., StandardV2_1, BasicV2_1)"
  type        = string
  default     = "StandardV2_1"

  validation {
    condition     = can(regex("^(StandardV2|BasicV2)_[0-9]+$", var.apim_sku_name))
    error_message = "apim_sku_name must be in format 'StandardV2_X' or 'BasicV2_X' where X is the capacity (e.g., StandardV2_1, BasicV2_1)."
  }
}

variable "networking_subscription_id" {
  description = "The Azure subscription ID for networking resources"
  type        = string
  default     = ""
  validation {
    condition     = var.networking_subscription_id == "" || can(regex("^[0-9a-fA-F-]{36}$", var.networking_subscription_id))
    error_message = "networking_subscription_id must be a valid GUID."
  }
}

variable "shared_subscription_id" {
  description = "The Azure subscription ID for shared resources"
  type        = string
  default     = ""
  validation {
    condition     = var.shared_subscription_id == "" || can(regex("^[0-9a-fA-F-]{36}$", var.shared_subscription_id))
    error_message = "shared_subscription_id must be a valid GUID."
  }
}

variable "apim_subscription_id" {
  description = "The Azure subscription ID for APIM resources"
  type        = string
  default     = ""
  validation {
    condition     = var.apim_subscription_id == "" || can(regex("^[0-9a-fA-F-]{36}$", var.apim_subscription_id))
    error_message = "apim_subscription_id must be a valid GUID."
  }
}

variable "enable_telemetry" {
  description = "Enable telemetry for the deployment"
  type        = bool
  default     = true
}
