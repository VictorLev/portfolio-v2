provider "digitalocean" {
  token = var.digitalocean_token
}

variable "digitalocean_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Region where the droplet will be created"
  type        = string
  default     = "nyc3" # Change Region to mtl
}

variable "image" {
  description = "Droplet image"
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "size" {
  description = "Droplet size"
  type        = string
  default     = "s-1vcpu-1gb"
}

resource "digitalocean_droplet" "ubuntu_droplet" {
  name   = "basic-ubuntu-droplet"
  region = var.region
  size   = var.size
  image  = var.image

  ssh_keys = [
    var.ssh_fingerprint
  ]
}

variable "ssh_fingerprint" {
  description = "SSH key fingerprint to access the droplet"
  type        = string
}

output "droplet_ip" {
  description = "The public IP address of the droplet"
  value       = digitalocean_droplet.ubuntu_droplet.ipv4_address
}
