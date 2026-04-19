output "function_app_name" {
  value = azurerm_linux_function_app.func.name
}

output "eventhub_name" {
  value = azurerm_eventhub.evh.name
}

output "container_app_url" {
  value = azurerm_container_app.app.latest_revision_fqdn
}