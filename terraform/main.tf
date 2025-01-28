terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "digitalocean" {
  token = var.digitalocean_token
}


# Create a new SSH key
resource "digitalocean_ssh_key" "intershop-ssh-key" {
  name       = "Ssh key used from intershop pc"
  public_key = file("/home/victor/.ssh/id_rsa.pub")
}

resource "digitalocean_droplet" "nginx_droplet" {
  image   = "ubuntu-20-04-x64"
  name    = "web-1"
  region  = "nyc3"
  size    = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.intershop-ssh-key.fingerprint]
}

resource "digitalocean_firewall" "nginx_firewall" {
  name = "nginx-firewall"

  droplet_ids = [digitalocean_droplet.nginx_droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80-443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol             = "tcp"
    port_range           = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "nginx_server_ip" {
  value = digitalocean_droplet.nginx_droplet.ipv4_address
}