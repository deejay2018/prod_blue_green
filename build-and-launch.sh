#!/bin/bash
# Packer log settings
export PACKER_LOG=1
export PACKER_LOG_PATH="packerlog.txt"
echo $PACKER_LOG
echo $PACKER_LOG_PATH
AMI_IDa=`packer build -machine-readable new.json | tee build.log `
AMI_ID=`grep 'artifact,0,id' build.log | cut -d, -f6 | cut -d: -f2`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > amivar.tf
terraform apply -auto-approve