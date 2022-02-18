variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type = string
}

variable "cf_api_token" {
  description = "Cloudflare API Token"
  type = string
}

variable "cf_zone_id" {
  description = "Cloudflare Zone ID"
  type = string
}

variable "cf_account_id" {
  description = "Cloudflare Account ID"
  type = string
}

variable "advancedautomation_server_count" {
  description = " Amount of advancedautomation-Server"
  type = number
  default = 1
}

