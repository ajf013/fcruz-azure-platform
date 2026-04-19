resource_group_name = "rg-demo"
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
  name          = "funcdemoaue123"
  runtime_stack = "node"
  version       = "~4"
}

create_storage_account = true

storage_account = {
  name = "stfuncaue12345"
}

eventhub_namespace = {
  name = "evhnsdemoaue"
  sku  = "Standard"
}

eventhub = {
  name              = "evhdemo"
  partition_count   = 2
  message_retention = 1
}

container_app_env = {
  name                       = "ca-env-demo"
  log_analytics_workspace_id = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.OperationalInsights/workspaces/<workspace>"
}

container_app = {
  name          = "ca-demo"
  revision_mode = "Single"

  template = {
    container = {
      name   = "app"
      image  = "nginx"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  ingress = {
    external_enabled = true
    target_port      = 80
  }
}