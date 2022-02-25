resource "hcloud_ssh_key" "marc" {
  name       = "Marc"
  public_key = file("~/.ssh/id_rsa.pub")
}

//Server creation
resource "hcloud_server" "webserver" {
count = var.advancedautomation_server_count
name = "${var.subdomain_name_cloudserver}${count.index}.nikio.io" 
image = "centos-stream-9" 
server_type = "cx11"
location = "nbg1"
ssh_keys = [
    hcloud_ssh_key.marc.id]
//network {
   // network_id = hcloud_network.advancedautomation_network.id
  //}
firewall_ids = [ hcloud_firewall.firewall.id    
]     
}
resource "cloudflare_record" "advancedautomation" {
  count = var.advancedautomation_server_count
  type = "A"
  zone_id = var.cf_zone_id
  name = "${var.subdomain_name_cloudserver}${count.index}.nikio.io"
  value = hcloud_server.webserver[count.index].ipv4_address
  ttl = 60 
}

//Loadbalancer creation
resource "hcloud_load_balancer" "loadbalancer1" {
  name               = "${var.domain_name_loadbalancer}"
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
  name = "advancedautomation.nikio.io"
  value = hcloud_load_balancer.loadbalancer1.ipv4
  ttl = 60 
}

//Firewall creation

resource "hcloud_firewall" "firewall" {
 name = "firewall"
 rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips =  [ "0.0.0.0/0", "::/0"] 
  }
   rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips =  ["${hcloud_load_balancer.loadbalancer1.ipv4}/32"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["${hcloud_load_balancer.loadbalancer1.ipv4}/32"]
  }
}



