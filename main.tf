provider "azurerm" {
  features {
    
  }
  subscription_id = "08a0553e-c405-4797-8f3c-4ea48da302a9"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
   
}

resource "azurerm_virtual_network" "vnet" {

  depends_on = [azurerm_resource_group.rg]
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  
}

resource "azurerm_subnet" "subnet" {
    depends_on = [ azurerm_virtual_network.vnet]
  name                 = "uipath-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  
}

resource "azurerm_public_ip" "pip" {

  name                = "uipath-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku = "Standard"
  
}

resource "azurerm_network_interface" "nic" {
  name                = "uipath-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
    
  }
  
}
resource "azurerm_virtual_machine" "uipath-vm" {
  depends_on = [ azurerm_public_ip.pip , azurerm_network_interface.nic]
  name                  = "uipath-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size = "Standard_B2s"

  storage_os_disk {
    name              = "uipath-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
 os_profile {
    computer_name  = "uipath-vm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = true
  }

  tags = {
    environment = "development"
  }
 }
