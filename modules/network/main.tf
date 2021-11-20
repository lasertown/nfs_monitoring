provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "network" {
  name                = var.region
  resource_group_name = var.rg
  location            = var.region
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 =  var.region
  virtual_network_name =  var.region
  resource_group_name  =  var.rg
  address_prefixes     = [ "10.0.0.0/24" ]
  depends_on = [ azurerm_virtual_network.network ]
}
