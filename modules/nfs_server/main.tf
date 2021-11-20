# Create network interface
resource "azurerm_network_interface" "nfs-0" {
    name                      = "nfs-0"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.example.name

    ip_configuration {
        name                          = "nfs-0-private"
        subnet_id                     = azurerm_subnet.example.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.0.6"
        primary                       = "true"
    }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "nfs-0" {
    name                  = "nfs-0"
    location              = var.region
    resource_group_name   = azurerm_resource_group.example.name
    network_interface_ids = [azurerm_network_interface.nfs-0.id]
    size                  = "Standard_DS2_v2"

    os_disk {
        name              = "nfs-0"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
        disk_size_gb      = "100"
    }

    source_image_reference {
        publisher = var.publisher
        offer     = var.offer
        sku       = var.sku
        version   = var._version
    }

    computer_name  = "nfs-0"
    availability_set_id = azurerm_availability_set.nfs.id
    admin_username = "azureadmin"
#    custom_data    = file("<path/to/file>")

    admin_ssh_key {
        username       = "azureadmin"
        public_key     = file("~/.ssh/lab_rsa.pub")
    }
}

resource "azurerm_managed_disk" "nfs-0a" {
  name                 = "${azurerm_linux_virtual_machine.nfs-0.name}-disk1a"
  location             = var.region
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}
resource "azurerm_virtual_machine_data_disk_attachment" "nfs-0a" {
  managed_disk_id    = azurerm_managed_disk.nfs-0a.id
  virtual_machine_id = azurerm_linux_virtual_machine.nfs-0.id
  lun                = "0"
  caching            = "None"
}

resource "azurerm_managed_disk" "nfs-0b" {
  name                 = "${azurerm_linux_virtual_machine.nfs-0.name}-disk1b"
  location             = var.region
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}
resource "azurerm_virtual_machine_data_disk_attachment" "nfs-0b" {
  managed_disk_id    = azurerm_managed_disk.nfs-0b.id
  virtual_machine_id = azurerm_linux_virtual_machine.nfs-0.id
  lun                = "1"
  caching            = "None"
}
