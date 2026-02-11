terraform {

  # for storage backends, see backend.tf.sample

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.1, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
    }
  }
}

# Configure the Microsoft Azure provider - default
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  use_oidc = true
  storage_use_azuread = true
  # subscription_id is read from ARM_SUBSCRIPTION_ID environment variable
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
}

# Provider alias for networking subscription
provider "azurerm" {
  alias = "networking"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  use_oidc = true
  storage_use_azuread = true
  subscription_id = var.networking_subscription_id != "" ? var.networking_subscription_id : null
}

# Provider alias for shared resources subscription
provider "azurerm" {
  alias = "shared"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  use_oidc = true
  storage_use_azuread = true
  subscription_id = var.shared_subscription_id != "" ? var.shared_subscription_id : null
}

# Provider alias for APIM subscription
provider "azurerm" {
  alias = "apim"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  use_oidc = true
  storage_use_azuread = true
  subscription_id = var.apim_subscription_id != "" ? var.apim_subscription_id : null
}

provider "azapi" {
  # Configuration options
}
