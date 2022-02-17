resource "hcloud_ssh_key" "marc" {
  name       = "Marc"
  public_key = file("~/.ssh/id_rsa.pub")
}

//Server creation
resource "hcloud_server" "advancedautomation" {
count = var.advancedautomation_server_count
name = "advancedautomation${count.index}.nikio.io" 
image = "centos-stream-9" 
server_type = "cx11"
location = "nbg1"
ssh_keys = [
    hcloud_ssh_key.marc.id]
}
resource "cloudflare_record" "advancedautomation" {
  count = var.advancedautomation_server_count
  type = "A"
  zone_id = var.cf_zone_id
  name = "advancedautomation${count.index}.nikio.io"
  value = hcloud_server.advancedautomation[count.index].ipv4_address
  ttl = 60 
}

//Loadbalancer creation
resource "hcloud_load_balancer" "advancedautomation_lb" {
  name               = "advancedautomation"
  load_balancer_type = "lb11"
  location           = "nbg1"
  }

  resource "hcloud_load_balancer_target" "load_balancer_target" {
  count = var.advancedautomation_server_count
  type             = "server"
  load_balancer_id = hcloud_load_balancer.advancedautomation_lb.id
  server_id        = hcloud_server.advancedautomation[count.index].id
}

resource "hcloud_load_balancer_service" "load_balancer_service_http" {
    load_balancer_id = hcloud_load_balancer.advancedautomation_lb.id
    protocol         = "http"
    
}

resource "hcloud_load_balancer_service" "load_balancer_service_https" {
    load_balancer_id = hcloud_load_balancer.advancedautomation_lb.id
    protocol         = "tcp"
    listen_port = 443
    destination_port = 443
}

  resource "cloudflare_record" "advancedautomation_lb" {
  type = "A"
  zone_id = var.cf_zone_id
  name = "advancedautomation.nikio.io"
  value = hcloud_load_balancer.advancedautomation_lb.ipv4
  ttl = 60 
}
