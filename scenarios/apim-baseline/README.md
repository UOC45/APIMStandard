# Scenario 1: Azure API Management - Secure Baseline

This reference implementation demonstrates a *secure baseline infrastructure architecture* for provisioning [Azure API Management](https://learn.microsoft.com/azure/api-management/) using the **Standard v2 SKU with Private Endpoints**. This architecture provides network isolation without requiring traditional VNet injection, making it simpler to deploy while maintaining enterprise-grade security.

Traffic flows through Azure Application Gateway (with WAF) to APIM via Private Endpoints, ensuring all API traffic remains within your virtual network.

By the end of this deployment guide, you would have deployed an Azure API Management Standard v2 instance secured with Private Endpoints.

![Architectural diagram showing an Azure API Management deployment with Private Endpoints.](../../docs/images/apim-secure-baseline.jpg)

## Core architecture components

- Azure API Management (Standard v2 SKU)
- Azure Virtual Networks
- Azure Application Gateway (with Web Application Firewall)
- Azure Private Endpoints (for APIM Gateway)
- Azure Private DNS Zones (privatelink.azure-api.net)
- Azure Standard Public IP
- Azure Key Vault
- Log Analytics Workspace
- Azure Application Insights

## Key Features

- **Standard v2 SKU**: Cost-effective, scalable APIM tier with enterprise features
- **Private Endpoints**: Network isolation without VNet injection complexity
- **Automatic DNS Registration**: Private DNS zones automatically resolve APIM endpoints
- **WAF Protection**: Application Gateway provides layer 7 protection
- **Observability**: Integrated Application Insights and Log Analytics

## Deploy the reference implementation

This reference implementation is provided with the following infrastructure as code options. Select the deployment guide you are interested in. They both deploy the same implementation.

:arrow_forward: [Bicep-based deployment guide](./bicep/README.md)
:arrow_forward: [Terraform-based deployment guide](./terraform/README.md)
