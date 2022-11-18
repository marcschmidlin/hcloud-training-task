[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
CF_Token='${cf_api_token}'

[webserver]
%{ for host in hosts ~}
${host} ansible_user=root
%{ endfor ~}


