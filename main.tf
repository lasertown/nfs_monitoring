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
offer = "sles-sap-15-sp3"
sku = "gen2"
_version = "latest"
}