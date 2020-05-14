#!/bin/bash
set +ex 

# todo genereate inventory.yml file with ec2 host
echo "all:">inventory.yml
echo "  hosts:">>inventory.yml
echo "    \"$(cd ../infra && terraform output instance_public_ip)\":">>inventory.yml
# todo add any additional variables


# ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yml -e 'record_host_keys=True' -u ec2-user --private-key ~/keys/ec2-key playbook.yml 

ANSIBLE_HOST_KEY_CHECKING=False sudo ansible-playbook -i inventory.yml -e 'record_host_keys=True' -u ec2-user --private-key ~/ec2/ec2-key --extra-vars "db_endpoint=$(cd ..&&terraform output db_endpoint)" playbook.yml
