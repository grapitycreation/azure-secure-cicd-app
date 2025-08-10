# Secure and Automated Web App Deployment on Azure with Terraform and GitHub Actions
**Status**: Completed | **Cloud**: Microsoft Azure | **IaC**: Terraform | **CI/CD**: GitHub Actions

This project demonstrates a best-practice approach to deploying a web application on Microsoft Azure in a secure, automated, and repeatable manner. The entire infrastructure is defined as code using Terraform, and the application deployment is fully automated through a CI/CD pipeline built with GitHub Actions.

1. Project Objectives
The primary goals of this project were to:

Provision a complete cloud infrastructure on Azure using Infrastructure as Code (IaC) principles with Terraform.

Implement a secure network architecture that isolates the application from the public internet, using a Virtual Network and an Application Gateway with a Web Application Firewall (WAF).

Build a fully automated CI/CD pipeline with GitHub Actions to deploy the application whenever new code is pushed to the main branch.

Gain hands-on experience with core Azure services, including App Service, Application Gateway, and Virtual Network.

Demonstrate practical skills relevant for Cloud, DevOps, and Security Engineer roles.

2. Architecture
The system is designed with a security-first mindset, ensuring that the application is not directly exposed to the internet.

Traffic Flow Diagram
This diagram illustrates how user traffic reaches the application securely.

Đoạn mã

graph TD
    A[User on the Internet] --> B{Public IP Address};
    B --> C[Azure Application Gateway <br> (WAF V2 Enabled)];
    subgraph "Virtual Network (vnet-secureapp) "
        C --> D[appgateway_subnet <br> 10.0.1.0/24];
        D --> E[appservice_subnet <br> 10.0.2.0/24];
    end
    E --> F[App Service <br> app-secureapp-immune-goblin ];

    style F fill:#cce5ff,stroke:#333,stroke-width:2px
    style C fill:#d5e8d4,stroke:#333,stroke-width:2px
All incoming traffic first hits the Application Gateway.

The Web Application Firewall (WAF) inspects the traffic for common threats (like SQL Injection, XSS) and blocks malicious requests.

Only legitimate traffic is forwarded to the App Service, which runs in an isolated subnet and has no public internet access.

CI/CD Workflow Diagram
This diagram shows the automated deployment process.

Đoạn mã

graph TD
    A[Developer] -- git push --> B[GitHub Repository <br> (main branch)];
    B -- Triggers --> C{GitHub Actions Workflow };
    C -- 1. Authenticates via Service Principal --> D[Azure API];
    C -- 2. Deploys Code --> E[App Service <br> app-secureapp-immune-goblin ];

    style C fill:#fff2cc,stroke:#333,stroke-width:2px
A 

git push to the main branch automatically triggers the GitHub Actions workflow.

The workflow securely logs into Azure using pre-configured credentials (a Service Principal).

The latest version of the application code is then deployed directly to the Azure App Service.

3. Tech Stack
Cloud Provider: Microsoft Azure


Infrastructure as Code (IaC): Terraform 





CI/CD: GitHub Actions 

Key Azure Services:


Azure App Service: To host the Python web application.






Azure Application Gateway (WAF V2): To act as a secure reverse proxy and web application firewall.






Azure Virtual Network (VNet): To provide network isolation.






Azure Public IP: The single entry point for the Application Gateway.


Azure for Students Subscription: Used for this project.

Application: Python (Flask)

4. Skills Demonstrated
This project showcases a comprehensive set of modern cloud engineering skills:

Cloud Engineering & DevOps

Infrastructure as Code (IaC): Proficient in using Terraform to define, provision, and manage the entire cloud infrastructure, ensuring consistency and repeatability.





CI/CD Pipeline Automation: Designed and implemented a complete CI/CD workflow from scratch using GitHub Actions to automate application deployments, reducing manual errors and increasing deployment speed.

Azure Resource Management: Hands-on experience deploying and configuring a wide range of Azure PaaS services.


Cost Management: Monitored and analyzed cloud spending using Azure Cost Management tools to understand the financial impact of architectural decisions.

Cloud Security & Networking
Secure Network Design: Implemented a secure network topology with VNets and Subnets, isolating the application backend from direct public access.

Web Application Firewall (WAF): Configured and deployed an Application Gateway with OWASP rules to protect the application against common web vulnerabilities.

Identity and Access Management (IAM): Created and configured a scoped Service Principal for secure, automated authentication between GitHub Actions and Azure, adhering to the principle of least privilege.

Version Control & Troubleshooting
Git & GitHub: Utilized Git for version control throughout the project lifecycle.

Advanced Problem-Solving: Successfully diagnosed and resolved a series of complex, real-world issues, including:

Git merge conflicts and history rewrites (reset, pull, rebase concepts).

Terraform state and provider issues (connection reset, MissingSubscriptionRegistration).

File size limitations and dependency management (.gitignore, .terraform directory).
