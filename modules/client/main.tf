provider "azurerm" {
  features {}
}

resource "random_id" "name" {
  byte_length = 8
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "nic-${random_id.name.hex}"
    location                  = var.region
    resource_group_name       = var.rg

    ip_configuration {
        name                          = "client-private"
        subnet_id                     = var.subnet
        private_ip_address_allocation = "Static"
        private_ip_address            = var.private_ip_address
    }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "client" {
    name                  = "client-${random_id.name.hex}"
    location              = var.region
    resource_group_name   = var.rg
    network_interface_ids = [azurerm_network_interface.nic.id]
    size                  = var.vm_size

    os_disk {
        name              = "osdisk-${random_id.name.hex}"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
        #disk_size_gb      = "128"
    }

    source_image_reference {
        publisher = var.publisher
        offer     = var.offer
        sku       = var.sku
        version   = var._version
    }

    computer_name  = "client"
    admin_username = "azureadmin"
    #custom_data    = file("<path/to/file>")

    admin_ssh_key {
        username       = "azureadmin"
        public_key     = file("~/.ssh/lab_rsa.pub")
    }
    
    tags = {
    group = "client"
    }
}
