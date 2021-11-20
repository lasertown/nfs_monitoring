output "bastion_ip" {
  value = module.bastion0.public_ip
}

output "rg" {
  value = module.rg0.rg
}
