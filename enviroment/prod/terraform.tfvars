# Resource Group
rgs2 = {
  rg = {
    name     = "rajivrg"
    location = "centralindia"
  }
}

stg2 = {
  stg = {
  name                     = "myinsecurestorage"
  resource_group_name      = "rajivrg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Bad Practice: Public Access Allowed!
  allow_nested_items_to_be_public = true 
  }
}

# Virtual Network
vnets2 = {
  vnets1 = {
    name                = "rajivvnet"
    resource_group_name = "rajivrg"
    location            = "centralindia"
    address_space       = ["10.0.0.0/16"]
  }
}

# Subnets (1 for VMs + 1 required for Azure Bastion)
subnets2 = {
  subnet1 = {
    subnet_name          = "rajivsnet1"
    resource_group_name  = "rajivrg"
    virtual_network_name = "rajivvnet"
    address_prefixes     = ["10.0.1.0/24"]
  }
  bastion_subnet = {
    subnet_name          = "AzureBastionSubnet"
    resource_group_name  = "rajivrg"
    virtual_network_name = "rajivvnet"
    address_prefixes     = ["10.0.3.0/24"]
  }
}

# NAT Gateway (Single subnet rajivsnet1 ke liye)
nat_gateways = {
  nat1 = {
    name                 = "rajiv-natgw"
    resource_group_name  = "rajivrg"
    location             = "centralindia"
    pip_name             = "rajiv-natgw-pip"
    virtual_network_name = "rajivvnet"
    subnet_names         = ["rajivsnet1"]
  }
}

# Network Interfaces (Dono NICs same rajivsnet1 me hain)
nics = {
  nic1 = {
    nic_name            = "Rajiv_nic_1"
    location            = "centralindia"
    resource_group_name = "rajivrg"
    subnet_name          = "rajivsnet1"
    virtual_network_name = "rajivvnet"
  }
  nic2 = {
    nic_name            = "Rajiv_nic_2"
    location            = "centralindia"
    resource_group_name = "rajivrg"
    subnet_name          = "rajivsnet1"
    virtual_network_name = "rajivvnet"
  }
}

# Linux VMs
vms2 = {
  vm1 = {
    vm_name             = "rajiv-vm-1"
    resource_group_name = "rajivrg"
    location            = "centralindia"
    vm_size             = "Standard_D2s_v5"
    admin_username      = "azureuser1"
    admin_password      = "26@Anaya&adhya"
    computer_name       = "ubuntuvm01"
    nic_name            = "Rajiv_nic_1"
  }
  vm2 = {
   vm_name             = "rajiv-vm-2"
   resource_group_name = "rajivrg"
    location            = "centralindia"
    vm_size             = "Standard_D2s_v5"
    admin_username      = "azureuser1"
    admin_password      = "26@Anaya&adhya"
    computer_name       = "ubuntuvm02"
    nic_name            = "Rajiv_nic_2"
  }
}

# Load Balancer
load_balancers = {
  lb1 = {
    name                = "rajiv-lb"
    resource_group_name = "rajivrg"
    location            = "centralindia"
    pip_name            = "rajiv-lb-pip"
    nic_names           = ["Rajiv_nic_1", "Rajiv_nic_2"]
  }
}

# Azure Bastion Host
bastions = {
  bastion1 = {
    name                 = "rajiv-bastion"
    resource_group_name  = "rajivrg"
    location             = "centralindia"
    virtual_network_name = "rajivvnet"
    subnet_name          = "AzureBastionSubnet"
    pip_name             = "rajiv-bastion-pip"
  }
}