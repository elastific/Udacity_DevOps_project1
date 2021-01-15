provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location

  tags = {environment = "TEST"}
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {environment = "TEST"}
}

resource "azurerm_network_security_group" "main" { 
  count                           = var.count_
  name                = "${var.prefix}_SecurityGroup-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                                        = "${var.prefix}_SecurityRule1"
    priority                                    = 100
    direction                                   = "Inbound"
    access                                      = "deny"
    destination_application_security_group_ids  = [azurerm_application_security_group.main.id]
    source_address_prefix                       = [""]
    # destination_address_prefix                  = []
    protocol                                    = "*"
    source_port_range                           = "*"
    destination_port_range                      = "*"
  }

  tags = {environment = "TEST"}
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]

}

resource "azurerm_application_security_group" "main" {
  name                = "${var.prefix}-asg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {environment = "TEST"}
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-PublicIp1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {environment = "TEST"}
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-LoadBalancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  tags = {environment = "TEST"}
}

resource "azurerm_lb_backend_address_pool" "main" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "${var.prefix}-BackEndAddressPool"

}


resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-aset"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {environment = "TEST"}
}

resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.count_
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.main.id]
  # virtual_machine_scale_set_id    = azurerm_availability_set.main.id

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {environment = "TEST"}
}

resource "azurerm_managed_disk" "main" {
  name                 = "${var.prefix}-md"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {environment = "TEST"}
}