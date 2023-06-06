provider "hcloud" {
  token = var.hcloud_token
}
provider "cloudflare" {
  api_token = var.cf_api_token
}
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.39.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.6.0"
    }
    local = {
    source  = "hashicorp/local"
    version = ">=1.4.0"
  }
}
}