#!/bin/bash

PLAYBOOK_FILE="delete_s3_object.yml"

if [ ! -f "$PLAYBOOK_FILE" ]; then
  echo "Playbook file $PLAYBOOK_FILE not found!"
  exit 1
fi
# Run the Ansible playbook
ansible-playbook delete_s3_object.yml

# Check the status of the playbook execution
# if [ $? -eq 0 ]; then
#   echo "Object deleted successfully from S3 bucket."
# else
#   echo "Failed to delete object from S3 bucket."
# fi