# my first terraform main.tf

# USe of Local Variables
locals {
  location   =  "Central India"
  tags = "Terraform_automate"
  virtual_network = {
    name = "vn_under_rg_terraform"
    add_sp = "10.1.0.0/16"
  }
} 

resource "azurerm_resource_group" "main" {
  name     = "rg_terraform"
  location = local.location

  tags = {
    "Env" = local.tags
  }
}

resource "azurerm_virtual_network" "main" {
  name                = local.virtual_network.name
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [local.virtual_network.add_sp]
  location            = azurerm_resource_group.main.location
  tags = {
    "Env" = "Terraform_automate"
  }
}

resource "azurerm_subnet" "subnetA" {
  name                 = "subnet_vn_under_rg_terraform"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "subnetB" {
  name                 = "subnet_vn_under_rg_terraform"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.10.0/24"]
}

resource "azurerm_network_interface" "internal" {
  name                 = "internal-nic"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetB.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.10.5"
    public_ip_address_id = azurerm_public_ip.publicip.id
    }
  depends_on = [
    azurerm_public_ip.publicip
  ]

}

resource "azurerm_public_ip" "publicip" {
  name = "pubip"
  resource_group_name = azurerm_resource_group.main.name
  location = local.location
  allocation_method = "Static"
}

resource "azurerm_storage_account" "stor-acc" {
  name = "terraforst"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  account_tier = "Standard"
  account_kind = "StorageV2"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container1" {
  name = "data"
  storage_account_name = azurerm_storage_account.stor-acc.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blob" {
  name = "maintf"
  storage_account_name = azurerm_storage_account.stor-acc.name
  storage_container_name = azurerm_storage_container.container1.name
  source = "main.tf"
  type = "Block"
  
}


resource "azurerm_linux_virtual_machine" "new_vm" {
  name                        = "terraform-in"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.internal.id]
  size = "Standard_B1s"
  disable_password_authentication = false
  admin_username = "abhishek"
  admin_password = "root@123"

  os_disk {
    caching = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
}

resource "azurerm_network_security_group" "subnetA" {
  name                = "nsg1"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_subnet.subnetA
  ]

}

resource "azurerm_subnet_network_security_group_association" "subnetA" {
  subnet_id                 = azurerm_subnet.subnetA.id
  network_security_group_id = azurerm_network_security_group.subnetA.id
}

resource "azurerm_managed_disk" "Disk1" {
  name                 = "disk1"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk1" {
  managed_disk_id = azurerm_managed_disk.Disk1.id
  virtual_machine_id = azurerm_linux_virtual_machine.new_vm.id
  lun = 2
  caching = "ReadWrite"
  depends_on = [
    azurerm_linux_virtual_machine.new_vm
  ]
}
output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.new_vm.id
}


