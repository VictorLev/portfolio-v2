provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "default-key"
  public_key = file(var.ssh_public_key_path)
}

resource "digitalocean_droplet" "nginx_droplet" {
  name   = "nginx-server"
  region = "nyc3" # Closest to Montreal
  size   = "s-1vcpu-1gb" # Smallest droplet
  image  = "ubuntu-22-04-x64"

  ssh_keys = [digitalocean_ssh_key.default.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update && apt-get install -y apt-transport-https curl docker.io
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    chmod +x kubectl && mv kubectl /usr/local/bin/
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube && mv minikube /usr/local/bin/
    usermod -aG docker root
  EOF

  tags = ["nginx", "minikube"]
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