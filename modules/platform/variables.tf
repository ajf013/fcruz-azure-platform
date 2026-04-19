##########################################################
# GLOBAL
##########################################################

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

##########################################################
# APP SERVICE PLAN
##########################################################

variable "app_service_plan" {
  type = object({
    name           = string
    sku_name       = string
    os_type        = string
    worker_count   = optional(number, 1)
    zone_balancing = optional(bool, false)
  })
}

##########################################################
# FUNCTION APP
##########################################################

variable "function_app" {
  type = object({
    name           = string
    os_type        = string
    runtime_stack  = string
    version        = string
    https_only     = optional(bool, true)
    app_settings   = optional(map(string), {})
  })
}

##########################################################
# STORAGE
##########################################################

variable "create_storage_account" {
  type    = bool
  default = true
}

variable "storage_account" {
  type = object({
    name = string
  })
  default = null
}

variable "storage_account_access_key" {
  type      = string
  default   = null
  sensitive = true
}

##########################################################
# EVENT HUB
##########################################################

variable "eventhub_namespace" {
  type = object({
    name                 = string
    sku                  = string
    capacity             = optional(number, 1)
    auto_inflate_enabled = optional(bool, false)
    max_throughput_units = optional(number, 0)
  })
}

variable "eventhub" {
  type = object({
    name              = string
    partition_count   = number
    message_retention = number
  })
}

##########################################################
# CONTAINER APP
##########################################################

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

      min_replicas = optional(number, 1)
      max_replicas = optional(number, 3)
    })

    ingress = object({
      external_enabled = bool
      target_port      = number
      traffic_weight   = optional(number, 100)
    })
  })
}