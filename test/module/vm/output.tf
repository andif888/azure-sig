output "avd_vm_ids" {
    value = azurerm_windows_virtual_machine.vm.*.id
}
output "avd_vm_private_ip_addresses" {
    value = azurerm_windows_virtual_machine.vm.*.private_ip_address
}
output "avd_vm_virtual_machine_ids" {
    value = azurerm_windows_virtual_machine.vm.*.virtual_machine_id
}
