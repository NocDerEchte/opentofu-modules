variable "name" {
  type = string
}

variable "node_name" {
  type        = string
  description = "Proxmox node where the VM will be created"
}

variable "bios" {
  type        = string
  description = "BIOS type for the VM"
  default     = "ovmf"
  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "Bios must be one of \"seabios\" or \"ovmf\""
  }
}

variable "datastore_id" {
  type        = string
  description = "Datastore ID where the VM disks will be created"
  default     = "local-lvm"
}

variable "cloud_image_url" {
  type        = string
  description = "URL of the cloud image to download for the VM"
  validation {
    condition     = can(regex("https?://.*", var.cloud_image_url))
    error_message = "cloud_image_url must be a valid URL matching the pattern \"https?://.*\""
  }
}

variable "network_bridge" {
  type        = string
  description = "Network bridge to attach the VM's network device to"
  default     = "vmbr0"
}

variable "network_model" {
  type        = string
  description = "Network model for the VM's network device"
  default     = "virtio"
  validation {
    condition = contains(
      [
        "e1000",
        "e1000e",
        "rtl8139",
        "virtio",
        "vmxnet3",
      ],
      var.network_model,
    )
    error_message = "network_model must be a valid model supported by Proxmox (e.g., \"virtio\", \"e1000\", etc.)"
  }
}

variable "network_vlan_id" {
  type        = number
  description = "VLAN ID for the VM's network device"
  default     = null
}

variable "on_boot" {
  type        = bool
  description = "Whether the VM should start on proxmox boot"
  default     = true
}

variable "started" {
  type        = bool
  description = "Whether the VM should be started after creation"
  default     = true
}

variable "migrate" {
  type        = bool
  description = "Whether the VM should be migrated if it already exists on another node"
  default     = true
}

variable "memory_dedicated" {
  type        = number
  description = "Dedicated memory for the VM"
  default     = 1024
}

variable "memory_floating" {
  type        = number
  description = "Floating memory for the VM (ballooning)"
  default     = 1024
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores for the VM"
  default     = 1
}

variable "cpu_sockets" {
  type        = number
  description = "Number of CPU sockets for the VM"
  default     = 1
}

variable "cpu_type" {
  type        = string
  description = "CPU type for the VM"
  default     = "host"
  validation {
    condition     = contains(["host", "kvm64", "qemu64"], var.cpu_type)
    error_message = "cpu_type must be one of \"host\", \"kvm64\", or \"qemu64\""
  }
}

variable "pool_id" {
  type        = string
  description = "Pool ID to assign the VM to"
  default     = null
}

variable "machine" {
  type        = string
  description = "Machine type for the VM"
  default     = "q35"
  validation {
    condition     = contains(["pc", "q35"], var.machine)
    error_message = "machine must be a valid machine type supported by Proxmox (e.g., \"pc\", \"q35\")"
  }
}

variable "tags" {
  type        = list(string)
  description = "Tags to assign to the VM"
  default     = []
}

variable "boot_disk" {
  type = object({
    datastore_id = string
    size         = number
    ssd          = bool
    iothread     = bool
    discard      = string
  })
  description = "Boot disk configuration for the VM. Image will be imported to this disk based on the cloud image URL."
}

variable "disks" {
  type = list(object({
    datastore_id = string
    size         = number
    ssd          = bool
    iothread     = bool
    discard      = string
  }))
  description = "List of disks to attach to the VM"
  default     = []
}

variable "description" {
  type        = string
  description = "Description of the VM"
  default     = "Managed by OpenTofu"
}

variable "vm_id" {
  type        = number
  description = "ID of the VM"
  default     = null
}

variable "ip_config_type" {
  type        = string
  description = "Type of IP configuration for the VM initialization (dhcp or static)"
  validation {
    condition     = var.ip_config_type == "dhcp" || var.ip_config_type == "static"
    error_message = "${var.ip_config_type} is not valid. Must be one of dhcp or static"
  }
  default = "dhcp"
}

variable "ipv4_address" {
  type        = string
  description = "Static IPv4 address to assign to the VM (required if ip_config_type is static)"
  default     = null
}

variable "ipv4_gateway" {
  type        = string
  description = "Static IPv4 gateway to assign to the VM (required if ip_config_type is static)"
  default     = null
}
