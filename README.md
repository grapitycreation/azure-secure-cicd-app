![6](https://github.com/user-attachments/assets/392bf62b-ec08-49e8-8581-0c7958a257c0)# 🚀 Azure Secure CI/CD Web App Deployment with Terraform & GitHub Actions

**Status:** ✅ Completed  
**Cloud:** Microsoft Azure  
**IaC:** Terraform  
**CI/CD:** GitHub Actions

---

## 📚 Project Overview

This project demonstrates a best-practice, security-focused approach to deploying a Python (Flask) web application on Microsoft Azure using Infrastructure as Code (Terraform) and automated deployment with GitHub Actions. The entire workflow is secure, automated, and repeatable—ideal for Cloud, DevOps, or Security Engineering roles.

---

## 🎯 Objectives

- **Provision** complete Azure infrastructure via Terraform (IaC principles).
- **Implement** a secure network architecture: isolate the app with Virtual Network & Application Gateway (with WAF).
- **Automate** deployment with a robust GitHub Actions CI/CD pipeline, triggered on every push to `main`.
- **Gain hands-on** with key Azure services: App Service, Application Gateway, Virtual Network.
- **Demonstrate** modern Cloud, DevOps & Security best practices.

---

## 🏗️ Architecture

### 🔒 Security-First Network Design

```mermaid
graph TD
    A[User on the Internet] --> B[Public IP Address]
    B --> C[Azure Application Gateway WAF V2 Enabled]
    subgraph Virtual_Network_vnet_secureapp
        C --> D[appgateway_subnet 10.0.1.0/24]
        D --> E[appservice_subnet 10.0.2.0/24]
    end
    E --> F[App Service app-secureapp-immune-goblin]

    style F fill:#cce5ff,stroke:#333,stroke-width:2px
    style C fill:#d5e8d4,stroke:#333,stroke-width:2px
```

- **All traffic** enters via Application Gateway (WAF).
- **WAF** inspects traffic for threats (SQL Injection, XSS, etc.) and blocks malicious requests.
- **App Service** is in an isolated subnet with **no public IP**; only reachable through the Gateway.

---

### 🔄 CI/CD Workflow

```mermaid
graph TD
    A[Developer] -->|git push| B[GitHub Repo main branch]
    B --> C[GitHub Actions Workflow]
    C -->|1. Auth via Service Principal| D[Azure API]
    C -->|2. Deploy Code| E[Azure App Service]

    style C fill:#fff2cc,stroke:#333,stroke-width:2px
```

- **git push** to `main` triggers the workflow.
- Workflow **authenticates securely** to Azure using Service Principal credentials.
- Deploys **latest code** to App Service automatically.

---

## 🛠️ Tech Stack

| Layer               | Technology                         |
| ------------------- | ---------------------------------- |
| **Cloud**           | Azure                              |
| **IaC**             | Terraform                          |
| **CI/CD**           | GitHub Actions                     |
| **App Hosting**     | Azure App Service (Python/Flask)   |
| **Security**        | Application Gateway (WAF V2)       |
| **Networking**      | Virtual Network, Subnets           |
| **Entry Point**     | Azure Public IP                    |
| **Subscription**    | Azure for Students                 |

---

## 💡 Key Skills Demonstrated

### Cloud Engineering & DevOps

- **Terraform IaC:** Full infra provisioning & management.
- **CI/CD Automation:** GitHub Actions for zero-touch deployments.
- **Azure Resource Management:** Deploy/configure PaaS resources.
- **Cost Management:** Monitor/analyze cloud spending.

### Cloud Security & Networking

- **Secure Network Design:** Isolated VNets & subnets.
- **WAF:** Application Gateway with OWASP rules.
- **IAM:** Scoped Service Principal (least privilege) for GitHub Actions.

### Version Control & Troubleshooting

- **Git & GitHub:** End-to-end VCS workflows.
- **Advanced Problem Solving:** 
  - Git conflicts & history rewrites (reset, pull, rebase).
  - Terraform state/provider issues.
  - File size limits & dependency management.

---

## 📂 Repository Structure

```
.
├── .github/workflows/         # GitHub Actions CI/CD pipelines
├── terraform/                 # All Terraform IaC modules & configs
├── app.py                       # Python Flask web application code
├── README.md                  # This documentation
└── ...
```

---

5. Project Execution Steps & Milestones
This section documents the step-by-step process of building the project from the ground up, including key commands and screenshots of the results at each stage.

Step 1: Foundation & Local Setup
Initialized a local project directory.

Developed a simple Python Flask application (app.py) to act as the workload.

Created a requirements.txt file to manage Python dependencies.

Established a remote repository on GitHub and performed the initial commit.

Installed and configured all necessary local tools: Git, Azure CLI, and Terraform.

Step 2: Provisioning the Core Infrastructure with Terraform
Authenticated with Azure using the Azure CLI (az login).

Created the initial Terraform configuration files (provider.tf, main.tf, variables.tf).

Ran terraform init to initialize the project and download the Azure provider.

Executed terraform apply to provision the foundational Azure Resource Group (rg-secureapp-project). This served as the container for all subsequent resources.

![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/1.jpg)
![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/2.jpg)

Step 3: Building the Network Foundation
The Terraform configuration was updated to include an Azure Virtual Network (VNet) (vnet-secureapp) and two dedicated Subnets:

snet-appgateway: For the Application Gateway.

snet-appservice: For the App Service's VNet integration.

Ran terraform apply to deploy the network resources. During this step, the NetworkWatcherRG was automatically created by Azure, which is expected behavior.

![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/3.jpg)

Step 4: Deploying the Secure Gateway (Application Gateway & WAF)
Added azurerm_public_ip and azurerm_application_gateway resources to the Terraform configuration.

Configured the Application Gateway with the WAF_v2 SKU and enabled the OWASP 3.2 ruleset in Prevention mode to provide robust security.

The deployment of the Application Gateway was a long-running operation that successfully provisioned the secure entry point for our application.

![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/4.jpg)
![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/5.jpg)

Step 5: Deploying the Application Host (App Service)
Added azurerm_service_plan (using the B1 SKU for VNet support) and azurerm_linux_web_app resources to the configuration.

Encountered and resolved a MissingSubscriptionRegistration error by running az provider register --namespace Microsoft.Web via the Azure CLI. This was a crucial real-world troubleshooting step.

Successfully deployed the App Service and configured its VNet Integration, ensuring it was placed securely within our private network.

![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/8.jpg)

Step 6: Completing the Traffic Flow
The azurerm_application_gateway resource in Terraform was modified to connect it to the App Service.

This involved:

Creating a Health Probe to monitor the App Service's availability.

Updating the Backend Pool to point to the App Service's Fully Qualified Domain Name (FQDN).

After applying the changes, the end-to-end traffic flow was verified by accessing the Application Gateway's public IP, which successfully displayed the default App Service page.
![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/7.jpg)

Step 7: Implementing CI/CD Automation with GitHub Actions
This was the final and most critical phase to achieve full automation.

A Service Principal was created in Azure with "Contributor" permissions scoped only to our project's Resource Group, following the principle of least privilege.

The JSON credentials of the Service Principal were stored securely as a repository secret named AZURE_CREDENTIALS in GitHub.

A CI/CD workflow file (.github/workflows/deploy.yml) was created to define the deployment process.

Upon pushing the new workflow file to the main branch, the GitHub Actions pipeline was triggered automatically. It successfully checked out the code, logged into Azure using the secret, and deployed the Python Flask application to the App Service.

![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/10.jpg)
![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/11.jpg)
![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/12.jpg)
![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/13.jpg)
![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/14.jpg)


Step 8: Final Result & Project Teardown
The final result is a live web application, served securely through the Application Gateway, and deployed automatically via a CI/CD pipeline.

The project lifecycle was completed by running terraform destroy to cleanly remove all created resources from Azure, preventing further costs and demonstrating the full power of Infrastructure as Code.

![image](https://github.com/grapitycreation/azure-secure-cicd-app/blob/main/images/15.jpg)


## 📎 Notes

- **For learning, reference, or direct use in your own secure Azure deployments.**
- **Contact:** [grapitycreation on GitHub](https://github.com/grapitycreation)

---

> _Designed for students and professionals aiming for excellence in secure, automated cloud deployments!_
