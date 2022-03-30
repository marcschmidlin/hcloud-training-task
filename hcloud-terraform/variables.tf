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

variable "domain_name" {
  description = "domain name"
  type = string
}

variable "domain_name_loadbalancer" {
  description = "IP range for the Network"
  type = string
}

variable "subdomain_name_cloudserver" {
  description = "Subdomain Name for Cloudserver"
  type = string
}
variable "subdomain_name_bastion" {
  description = "Subdomain Name for Bastion VM"
  type = string
}
variable "ip_range_network" {
  description = "IP range for the Network"
  type = string
  default = "10.0.0.0/16"
}
variable "ip_range_subnet" {
  description = "IP range for Subnet"
  type = string
  default = "10.0.1.0/24"
}

