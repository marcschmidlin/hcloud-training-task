provider "hcloud" {
  token = var.hcloud_token
}
provider "cloudflare" {
  version = "~> 3.0"
  api_token = var.cf_api_token
}
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    local = {
    source  = "hashicorp/local"
    version = ">=1.4.0"
  }
}
}