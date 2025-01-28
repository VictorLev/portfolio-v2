variable "digitalocean_token" {}

variable "ssh_private_key" {
  description = "The private SSH key"
  type        = string
}

variable "ssh_public_key" {
  description = "The public SSH key"
  type        = string
}

