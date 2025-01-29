terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "digitalocean" {
  token = var.digitalocean_token
}

# Get ssh key from DigitalOcean
data "digitalocean_ssh_key" "intershop-ssh-key" {
  name       = "Ssh key used from intershop pc"
}

resource "digitalocean_droplet" "nginx_droplet" {
  image   = "docker-20-04" # DO Ubuntu 20.04 image with Docker pre-installed
  name    = "web-1"
  region  = "nyc3"
  size    = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.intershop-ssh-key.fingerprint]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa")  # Update with your private key path
      host        = self.ipv4_address
    }

    inline = [
      # Install Minikube
      "curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "chmod +x minikube",
      "mv minikube /usr/local/bin/",
      
      # Add user to docker group
      "usermod -aG docker root",

      "mkdir -p /deploy"
    ]    
  }
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