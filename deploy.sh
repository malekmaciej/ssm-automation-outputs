#!/bin/bash
terraform init 
terraform fmt --recursive
terraform plan -out=build.plan
if [[ $? -eq 0 ]]
then
    terraform apply build.plan
    rm -f build.plan
else
    echo "ERROR: Unable to proceed due to plan failure"
fi