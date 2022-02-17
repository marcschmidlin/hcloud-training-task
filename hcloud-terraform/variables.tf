variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type = string
}

variable "cf_api_key" {
  description = "Cloudflare API Key"
  type = string
}

variable "cf_email" {
  description = "Cloudflare E-Mail"
  type = string
}


variable "cf_zone_id" {
  description = "Cloudflare Zone ID"
  type = string
}

variable "advancedautomation_server_count" {
  description = " Amount of advancedautomation-Server"
  type = number
  default = 1
}

