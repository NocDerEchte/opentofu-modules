output "vm_name" {
  value       = proxmox_virtual_environment_vm.linux_img.name
  description = "Name of the created VM"
}

output "ipv4_addresses" {
  value       = proxmox_virtual_environment_vm.linux_img.ipv4_addresses
  description = "IPv4 addresses assigned to the VM"
}

output "ipv6_addresses" {
  value       = proxmox_virtual_environment_vm.linux_img.ipv6_addresses
  description = "IPv6 addresses assigned to the VM"
}
