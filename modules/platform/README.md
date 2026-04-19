# Azure Platform Terraform Module

## 📌 Overview

This module provisions a **composite Azure platform stack** using Terraform with the AzureRM provider.

It includes:

* App Service Plan
* Function App (Linux)
* Event Hub Namespace + Event Hub
* Azure Container Apps Environment + Container App

This module is designed for:

* Reusability
* Standardization
* Enterprise-ready deployments

---

# 🏗️ Architecture

### 🔹 Architecture Explanation

* Function App runs on **App Service Plan**
* Uses **Storage Account (required)**
* Access secured via **Managed Identity + RBAC**
* Event Hub handles messaging
* Container Apps run microservices
* Log Analytics supports observability

---

# 🔄 Deployment Flow

### 🔹 Execution Flow

```text
User (terraform.tfvars)
        ↓
terraform init
        ↓
terraform validate
        ↓
terraform plan (detect changes)
        ↓
terraform apply
        ↓
Azure Resources Created/Updated
```

---

## ⚙️ Requirements

| Name             | Version  |
| ---------------- | -------- |
| Terraform        | >= 1.5.0 |
| AzureRM Provider | ~> 3.100 |

---

## 🔐 Provider Configuration

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}
```

---

# 🚀 Usage

### Basic Example

```hcl
module "platform" {
  source = "./modules/platform"

  resource_group_name = "rg-existing-aue"
  location            = "Australia East"

  tags = {
    env = "dev"
  }

  app_service_plan = {
    name     = "asp-demo"
    sku_name = "P1v2"
    os_type  = "Linux"
  }

  function_app = {
    name          = "func-demo"
    runtime_stack = "node"
    version       = "~4"
  }

  create_storage_account = true

  storage_account = {
    name = "stnewdemo12345"
  }
}
```

---

# 📄 terraform.tfvars (User Controls Behavior)

### 🔹 Case 1: Create Storage

```hcl
create_storage_account = true

storage_account = {
  name = "stnewdemo12345"
}
```

### 🔹 Case 2: Use Existing Storage

```hcl
create_storage_account = false

storage_account = {
  name = "existingstorage12345"
}
```

---

# ⚠️ IMPORTANT RULES

✔ Resource Group must exist
✔ Storage depends on flag
✔ RBAC always auto-assigned

---

# 🎯 Behavior Summary

| Scenario | Storage       | RG       | RBAC       |
| -------- | ------------- | -------- | ---------- |
| true     | ✅ Created     | Existing | ✅ Assigned |
| false    | ❌ Not created | Existing | ✅ Assigned |

---

# 📥 Inputs (Auto-Generated via terraform-docs)

### Inputs

| Name                   | Type   | Description                    | Required |
| ---------------------- | ------ | ------------------------------ | -------- |
| resource_group_name    | string | Existing Resource Group        | Yes      |
| location               | string | Azure region                   | Yes      |
| create_storage_account | bool   | Create storage or use existing | Yes      |
| storage_account        | object | Storage configuration          | Yes      |
| app_service_plan       | object | App Service Plan config        | Yes      |
| function_app           | object | Function App config            | Yes      |
| eventhub_namespace     | object | Event Hub namespace            | Yes      |
| eventhub               | object | Event Hub config               | Yes      |
| container_app          | object | Container App config           | Yes      |

---

### Outputs

| Name              | Description            |
| ----------------- | ---------------------- |
| function_app_name | Function App name      |
| eventhub_name     | Event Hub name         |
| container_app_url | Container App endpoint |

---

# 🔧 terraform-docs Setup

Install:

```bash
brew install terraform-docs
```

Generate docs:

```bash
terraform-docs markdown table . > README.md
```

👉 Or use config file:

`.terraform-docs.yml`

```yaml
formatter: markdown
output:
  file: README.md
  mode: inject
```

---

# 🔄 Deployment

```bash
az login
terraform init
terraform plan
terraform apply
```

---

# 🧠 Notes

* Function App requires storage
* Managed Identity removes secrets
* RBAC may take 1–2 minutes
* Storage names must be unique

---

# 🛡️ Security

* No secrets in tfvars
* Managed Identity preferred
* Optional Key Vault integration

---

# 👨‍💻 User Guidelines

### Modify:

* terraform.tfvars

### Do NOT modify:

* modules/*
* main.tf

---

# 📌 Known Limitations

* Linux only
* No VNet integration

---

# 📄 License

MIT License
