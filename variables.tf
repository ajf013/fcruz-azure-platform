variable "resource_group_name" {
  type        = string
  description = "Existing Resource Group name"

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "You must provide an existing Resource Group."
  }
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "app_service_plan" {
  type = object({
    name     = string
    sku_name = string
    os_type  = string
  })
}

variable "function_app" {
  type = object({
    name          = string
    runtime_stack = string
    version       = string
  })
}

variable "create_storage_account" {
  type    = bool
  default = true
}

variable "storage_account" {
  type = object({
    name = string
  })
}

variable "eventhub_namespace" {
  type = object({
    name = string
    sku  = string
  })
}

variable "eventhub" {
  type = object({
    name              = string
    partition_count   = number
    message_retention = number
  })
}

variable "container_app_env" {
  type = object({
    name                       = string
    log_analytics_workspace_id = string
  })
}

variable "container_app" {
  type = object({
    name          = string
    revision_mode = string

    template = object({
      container = object({
        name   = string
        image  = string
        cpu    = number
        memory = string
      })
    })

    ingress = object({
      external_enabled = bool
      target_port      = number
    })
  })
}