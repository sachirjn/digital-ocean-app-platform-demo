terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.5.1"
    }
  }
}

provider "digitalocean" {
  token = var.token
}
