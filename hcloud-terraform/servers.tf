resource "hcloud_ssh_key" "marc" {
  name       = "Marc"
  public_key = file("~/.ssh/id_rsa.pub")
}



//Server creation
resource "hcloud_server" "webserver" {
count = var.advancedautomation_server_count
name = "${var.subdomain_name_cloudserver}${count.index}.${var.domain_name}" 
image = "centos-stream-9" 
server_type = "cx11"
location = "nbg1"
ssh_keys = [
    hcloud_ssh_key.marc.id]
network {
   network_id = hcloud_network.network.id
   }
firewall_ids = [ hcloud_firewall.firewall.id    
]     
}
resource "cloudflare_record" "advancedautomation" {
  count = var.advancedautomation_server_count
  type = "A"
  zone_id = var.cf_zone_id
  name = "${var.subdomain_name_cloudserver}${count.index}.${var.domain_name}"
  value = element(hcloud_server.webserver[count.index].network.*.ip, 0)
  ttl = 60 
}



//Bastion creation
resource "hcloud_server" "bastion" {
name = "bastion.nikio.io" 
image = "centos-stream-9" 
server_type = "cx11"
location = "nbg1"
ssh_keys = [
    hcloud_ssh_key.marc.id]
network {
    network_id = hcloud_network.network.id
  }
firewall_ids = [ hcloud_firewall.bastion-firewall.id    
]     
}
resource "cloudflare_record" "bastion" {
  type = "A"
  zone_id = var.cf_zone_id
  name = "bastion.nikio.io"
  value = hcloud_server.bastion.ipv4_address
  ttl = 60 
}



//Loadbalancer creation
resource "hcloud_load_balancer" "loadbalancer1" {
  name               = "${var.domain_name_loadbalancer}.${var.domain_name}"
  load_balancer_type = "lb11"
  location           = "nbg1"
  }
resource "hcloud_load_balancer_target" "load_balancer_target" {
  count = var.advancedautomation_server_count
  type             = "server"
  load_balancer_id = hcloud_load_balancer.loadbalancer1.id
  server_id        = hcloud_server.webserver[count.index].id
}
resource "hcloud_load_balancer_service" "load_balancer_service_http" {
    load_balancer_id = hcloud_load_balancer.loadbalancer1.id
    protocol         = "http"  
}
resource "hcloud_load_balancer_service" "load_balancer_service_https" {
    load_balancer_id = hcloud_load_balancer.loadbalancer1.id
    protocol         = "tcp"
    listen_port = 443
    destination_port = 443
}
resource "cloudflare_record" "advancedautomation_lb" {
  type = "A"
  zone_id = var.cf_zone_id
  name = "${var.domain_name_loadbalancer}.${var.domain_name}"
  value = hcloud_load_balancer.loadbalancer1.ipv4
  ttl = 60 
}
resource "hcloud_load_balancer_network" "loadbalancernetwork" {
  load_balancer_id = hcloud_load_balancer.loadbalancer1.id
  network_id       = hcloud_network.network.id
}



//Firewall creation
resource "hcloud_firewall" "firewall" {
 name = "firewall"
 rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips =  ["${element(hcloud_server.bastion.network.*.ip, 0)}/32"] 
  }
   rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips =  ["${hcloud_load_balancer.loadbalancer1.ipv4}/32", "${hcloud_server.bastion.ipv4_address}/32"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["${hcloud_load_balancer.loadbalancer1.ipv4}/32", "${hcloud_server.bastion.ipv4_address}/32"]
  }
}



//Firewall Bastion creation
resource "hcloud_firewall" "bastion-firewall" {
 name = "bastion-firewall"
 rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips =  ["0.0.0.0/0", "::/0"] 
  }
}



//Network creation
resource "hcloud_network" "network" {
  name     = "my-net"
 ip_range = var.ip_range_network
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.ip_range_subnet
}


