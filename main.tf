module "rg0" {
  source = "./modules/resource_group"
  rg = "nfs_monitoring"
}

module "network0" {
    source = "./modules/network"
    rg = module.rg0.rg
    region = "westus2"
}

module "bastion0" {
source = "./modules/bastion"
rg = module.rg0.rg
region = module.network0.region
subnet = module.network0.subnet
vm_size = "Standard_E4s_v3"
publisher = "SUSE"
offer = "sles-15-sp3"
sku = "gen2"
_version = "latest"
}

module "nfs_server0" {
source = "./modules/nfs_server"
rg = module.rg0.rg
region = module.network0.region
subnet = module.network0.subnet
vm_size = "Standard_D8s_v5"
publisher = "SUSE"
offer = "sles-15-sp3"
sku = "gen2"
_version = "latest"
}

module "client0" {
source = "./modules/client"
rg = module.rg0.rg
region = module.network0.region
subnet = module.network0.subnet
vm_size = "Standard_E4s_v3"
private_ip_address = "10.0.0.10"
publisher = "SUSE"
offer = "sles-15-sp3"
sku = "gen2"
_version = "latest"
}

module "client1" {
source = "./modules/client"
rg = module.rg0.rg
region = module.network0.region
subnet = module.network0.subnet
vm_size = "Standard_E4s_v3"
private_ip_address = "10.0.0.11"
publisher = "SUSE"
offer = "sles-15-sp3"
sku = "gen2"
_version = "latest"
}
  
module "client2" {
source = "./modules/client"
rg = module.rg0.rg
region = module.network0.region
subnet = module.network0.subnet
vm_size = "Standard_E4s_v3"
private_ip_address = "10.0.0.12"
publisher = "SUSE"
offer = "sles-15-sp3"
sku = "gen2"
_version = "latest"
}
