# generate inventory file for Ansible
resource "local_file" "ansible-hosts" {
  content = templatefile("template.tpl",
    {
      hosts = cloudflare_record.advancedautomation[*].hostname
      cf_account_id = var.cf_account_id
      cf_api_token = var.cf_api_token
      cf_zone_id = var.cf_zone_id
    }
  )
  filename = "terraform-hosts"
}