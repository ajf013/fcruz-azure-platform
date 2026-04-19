module "platform" {
  source = "./modules/platform"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  app_service_plan = var.app_service_plan
  function_app     = var.function_app

  create_storage_account = var.create_storage_account
  storage_account        = var.storage_account

  eventhub_namespace = var.eventhub_namespace
  eventhub           = var.eventhub

  container_app_env = var.container_app_env
  container_app     = var.container_app
}