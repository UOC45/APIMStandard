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

variable "apimCSVNetNameAddressPrefix" {
  description = "APIM CSV Net Name Address Prefix"
  type        = string
  default     = "10.2.0.0/16"
}

variable "appGatewayAddressPrefix" {
  description = "App Gateway Address Prefix"
  type        = string
  default     = "10.2.4.0/24"
}

variable "privateEndpointAddressPrefix" {
  description = "Private Endpoint Address Prefix"
  type        = string
  default     = "10.2.5.0/24"
}

variable "deploymentAddressPrefix" {
  description = "Deployment Address Prefix"
  type        = string
  default     = "10.2.8.0/24"
}

variable "zones" {
  description = "Availability zones for zone-redundant resources. Use empty list for regions without zone support."
  type        = list(string)
  default     = ["1", "2", "3"]
}