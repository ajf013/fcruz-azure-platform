##########################################################
# VALIDATION (IMPORTANT)
##########################################################

# Ensure storage_account is provided
locals {
  storage_name = var.storage_account.name
}

##########################################################
# STORAGE ACCOUNT (OPTIONAL CREATION)
##########################################################

resource "azurerm_storage_account" "this" {
  count = var.create_storage_account ? 1 : 0

  name                     = local.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

##########################################################
# EXISTING STORAGE ACCOUNT (IF NOT CREATING)
##########################################################

data "azurerm_storage_account" "existing" {
  count = var.create_storage_account ? 0 : 1

  name                = local.storage_name
  resource_group_name = var.resource_group_name
}

##########################################################
# LOCALS
##########################################################

locals {
  storage_account_name = var.create_storage_account
    ? azurerm_storage_account.this[0].name
    : data.azurerm_storage_account.existing[0].name

  storage_account_id = var.create_storage_account
    ? azurerm_storage_account.this[0].id
    : data.azurerm_storage_account.existing[0].id
}

##########################################################
# APP SERVICE PLAN
##########################################################

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.app_service_plan.os_type
  sku_name            = var.app_service_plan.sku_name

  tags = var.tags
}

##########################################################
# FUNCTION APP (MANAGED IDENTITY)
##########################################################

resource "azurerm_linux_function_app" "func" {
  name                = var.function_app.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.asp.id

  storage_account_name = local.storage_account_name

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  app_settings = merge(
    var.function_app.app_settings,
    {
      "AzureWebJobsStorage__accountName" = local.storage_account_name
    }
  )

  tags = var.tags
}

##########################################################
# RBAC - STORAGE ACCESS
##########################################################

resource "azurerm_role_assignment" "func_storage" {
  scope                = local.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.func.identity[0].principal_id

  depends_on = [
    azurerm_linux_function_app.func
  ]
}

##########################################################
# EVENT HUB
##########################################################

resource "azurerm_eventhub_namespace" "ns" {
  name                = var.eventhub_namespace.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.eventhub_namespace.sku

  tags = var.tags
}

resource "azurerm_eventhub" "evh" {
  name                = var.eventhub.name
  namespace_name      = azurerm_eventhub_namespace.ns.name
  resource_group_name = var.resource_group_name
  partition_count     = var.eventhub.partition_count
  message_retention   = var.eventhub.message_retention
}

##########################################################
# CONTAINER APPS
##########################################################

resource "azurerm_container_app_environment" "env" {
  name                       = var.container_app_env.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.container_app_env.log_analytics_workspace_id
}

resource "azurerm_container_app" "app" {
  name                         = var.container_app.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.container_app.revision_mode

  template {
    container {
      name   = var.container_app.template.container.name
      image  = var.container_app.template.container.image
      cpu    = var.container_app.template.container.cpu
      memory = var.container_app.template.container.memory
    }

    min_replicas = var.container_app.template.min_replicas
    max_replicas = var.container_app.template.max_replicas
  }

  ingress {
    external_enabled = var.container_app.ingress.external_enabled
    target_port      = var.container_app.ingress.target_port

    traffic_weight {
      percentage      = var.container_app.ingress.traffic_weight
      latest_revision = true
    }
  }

  tags = var.tags
}