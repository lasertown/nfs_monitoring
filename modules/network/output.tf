output "subnet" {
  value = azurerm_subnet.subnet.id
}

output "region" {
  value = azurerm_virtual_network.network.name
}
