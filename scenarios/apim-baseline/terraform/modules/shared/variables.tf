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

variable "keyVaultName" {
  type        = string
  description = "The name of the Key Vault"
}

variable "keyVaultSku" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium"
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.keyVaultSku)
    error_message = "keyVaultSku must be either 'standard' or 'premium'."
  }
}

variable "additionalClientIds" {
  description = "List of additional clients to add to the Key Vault access policy."
  type        = list(string)
  default     = []
}

variable "deploymentSubnetId" {
  type        = string
  description = "The ID of the deployment subnet for container instances"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account for deployment scripts"
}

variable "log_retention_days" {
  description = "Log Analytics workspace retention in days (30-730)"
  type        = number
  default     = 30

  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "log_retention_days must be between 30 and 730 days."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
