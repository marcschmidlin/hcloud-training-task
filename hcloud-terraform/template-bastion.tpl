[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
CF_Token='${cf_api_token}'

[webserver]
%{ for host in hosts ~}
${host} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
%{ endfor ~}

[webserver:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -W %h:%p -q bastion"'