[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
CF_Account_ID='${cf_account_id}'
CF_Token='${cf_api_key}'
CF_Zone_ID='${cf_zone_id}

[webserver]
%{ for host in hosts ~}
${host} ansible_user=root
%{ endfor ~}

