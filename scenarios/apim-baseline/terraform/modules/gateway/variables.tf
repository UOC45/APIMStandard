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

variable "appGatewayCertType" {
  description = "selfsigned will create a self-signed certificate for the APPGATEWAY_FQDN. custom will use an existing certificate in pfx format that needs to be available in the [certs](../../certs) folder and named appgw.pfx "
  default     = "selfsigned"
}

variable "keyvaultId" {
  type        = string
  description = "The ID of the Key Vault"
  default     = null
}

variable "appGatewayFqdn" {
  type        = string
  description = "The Azure location to deploy to"
  default     = "apim.example.com"
}

variable "certificate_path" {
  type        = string
  description = "The file path to the PFX certificate for the Application Gateway SSL termination"
  default     = null
}

variable "certificate_password" {
  type        = string
  sensitive   = true
  description = "The password for the PFX certificate used by the Application Gateway"
}

variable "subnetId" {
  type        = string
  description = "The subnet ID for the Application Gateway deployment"
}

variable "primaryBackendFqdn" {
  type        = string
  description = "The FQDN of the primary backend (APIM gateway) for routing traffic"
}

variable "probe_url" {
  type        = string
  description = "The URL path used for the Application Gateway health probe against the backend"
  default     = "/status-0123456789abcdef"
}
