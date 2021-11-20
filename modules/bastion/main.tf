provider "azurerm" {
  features {}
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "ssh" {
    name                = var.region
    location            = var.region
    resource_group_name = var.rg

    security_rule {
        name                       = "SSH"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "nsga" {
  subnet_id                 = var.subnet
  network_security_group_id = azurerm_network_security_group.ssh.id
}

# Create public IPs
resource "azurerm_public_ip" "ip" {
    name                         = var.region
    location                     = var.region
    resource_group_name          = var.rg
    allocation_method            = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = var.region
    location                  = var.region
    resource_group_name       = var.rg

    ip_configuration {
        name                          = "bastion-public"
        subnet_id                     = var.subnet
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.0.101"
        public_ip_address_id          = azurerm_public_ip.ip.id
        primary                       = "true"
    }

    ip_configuration {
        name                          = "bastion-private"
        subnet_id                     = var.subnet
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.0.100"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "isga" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.ssh.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "bastion" {
    name                  = "bastion-${var.region}"
    location              = var.region
    resource_group_name   = var.rg
    network_interface_ids = [azurerm_network_interface.nic.id]
    size                  = var.vm_size

    os_disk {
        name              =  var.region
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

    computer_name  = "bastion-${var.region}"
    admin_username = "azureadmin"
    #custom_data    = file("<path/to/file>")

    admin_ssh_key {
        username       = "azureadmin"
        public_key     = file("~/.ssh/lab_rsa.pub")
    }
    
    tags = {
    group = "bastion"
    }
}
