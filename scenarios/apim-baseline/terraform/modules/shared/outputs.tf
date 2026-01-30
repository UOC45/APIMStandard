output "workspaceId" {
  description = "The id of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "instrumentationKey" {
  description = "The instrumentation key of the Application Insights instance"
  value       = azurerm_application_insights.shared_apim_insight.instrumentation_key
  sensitive   = true
}

output "appInsightsId" {
  description = "The resource ID of the Application Insights instance"
  value       = azurerm_application_insights.shared_apim_insight.id
}

output "keyVaultId" {
  description = "The resource ID of the Key Vault"
  value       = azurerm_key_vault.key_vault.id
}

output "keyVaultName" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "deploymentIdentityName" {
  description = "The name of the deployment managed identity"
  value       = azurerm_user_assigned_identity.privatedeploymanagedidentity.name
}

output "deploymentStorageName" {
  description = "The name of the deployment storage account"
  value       = azurerm_storage_account.privatedeploystorage.name
}
