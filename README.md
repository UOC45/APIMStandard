# Azure API Management Landing Zone Accelerator

Azure API Management Landing Zone Accelerator provides packaged guidance with reference architecture and reference implementation along with design guidance recommendations and considerations on critical design areas for provisioning APIM with a secure baseline. They are aligned with industry proven practices, such as those presented in [Azure landing zones](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/) guidance in the Cloud Adoption Framework.

## :mag: Design areas

The enterprise architecture is broken down into six different design areas, where you can find the links to each at:
| Design Area|Considerations|Recommendations|
|:--------------:|:--------------:|:--------------:|
| Identity and Access Management|[Design Considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/identity-and-access-management#design-considerations)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/identity-and-access-management#design-recommendations)|
| Network Topology and Connectivity|[Design Considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/network-topology-and-connectivity#design-considerations)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/network-topology-and-connectivity#design-recommendations)|
| Security|[Design Considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/security#design-considerations)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/security#design-recommendations)|
| Management|[Design Considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/management#design-considerations)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/management#design-recommendation)|
| Governance|[Design Considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/governance#design-considerations)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/governance#design-recommendations)|
| Platform Automation and DevOps|[Design Considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/platform-automation-and-devops#design-considerations)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/platform-automation-and-devops#design-recommendations)|

## :rocket: Deployment scenarios

This repo contains the Azure landing zone accelerator's reference implementations, all with supporting *Infrastructure as Code* artifacts. The scenarios covered are:

### :arrow_forward: [Scenario 1: Azure API Management - Secure Baseline](scenarios/apim-baseline/README.md)

Deploys APIM Standard v2 with Private Endpoints for secure network isolation, including Application Gateway with WAF and a sample Echo API. 

### :arrow_forward: [Scenario 2: Azure API Management - Function Backend](scenarios/workload-functions/README.md)

On top of the secure baseline, deploys a private Azure function as a backend and provision APIs in APIM to access the function.

### :arrow_forward: [Scenario 3: Azure API Management - Gen AI Backend](scenarios/workload-genai/README.md)

On top of the secure baseline, deploys private Azure OpenAI endpoints (3 endpoints) as backend and provision API that can handle [multiple use cases.](./scenarios/workload-genai/README.md#scenarios-handled-by-this-accelerator)

*More reference implementation scenarios will be added as they become available.*

### Supported Regions

Some of the new Azure OpenAI policies are not available in al the regions yet. If you see the deployment failures, try chosing a different region. The following regions are more likely to work.

```shell
australiacentral, australiaeast, australiasoutheast, brazilsouth, eastasia, francecentral, germanywestcentral, koreacentral, northeurope, southeastasia, southcentralus, uksouth, ukwest, westeurope, westus2, westus3
```




