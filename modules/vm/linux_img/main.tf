terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.93.0"
    }
  }
  required_version = "v1.10.5"
}

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.node_name
  url          = var.cloud_image_url
}

resource "proxmox_virtual_environment_vm" "linux_img" {
  name      = var.name
  node_name = var.node_name

  description = var.description
  tags        = var.tags
  vm_id       = var.vm_id
  pool_id     = var.pool_id

  bios    = var.bios
  machine = var.machine

  migrate = var.migrate
  started = var.started

  on_boot = var.on_boot

  dynamic "efi_disk" {
    for_each = var.bios == "ovmf" ? [1] : []

    content {
      datastore_id = var.datastore_id
      type         = "4m"
    }
  }

  disk {
    ssd          = var.boot_disk.ssd
    datastore_id = var.boot_disk.datastore_id
    size         = var.boot_disk.size
    interface    = var.boot_disk.interface
    iothread     = var.boot_disk.iothread
    discard      = var.boot_disk.discard
    import_from  = proxmox_virtual_environment_download_file.cloud_image.id
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      ssd          = disk.value.ssd
      datastore_id = disk.value.datastore_id
      size         = disk.value.size
      interface    = disk.value.interface
      iothread     = disk.value.iothread
      discard      = disk.value.discard
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_config_type == "static" ? var.ipv4_address : "dhcp"
        gateway = var.ip_config_type == "static" ? var.ipv4_gateway : null
      }
    }
  }

  network_device {
    bridge  = var.network_bridge
    model   = var.network_model
    vlan_id = var.network_vlan_id
  }

  agent {
    enabled = true
  }

  memory {
    dedicated = var.memory_dedicated
    floating  = var.memory_floating
  }

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }
}
