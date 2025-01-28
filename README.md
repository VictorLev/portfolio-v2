# portfolio-v2


# Terrafrom apply commands
export $(cat .env | xargs) # Refresh variables
terraform apply -auto-approve -var-file="local.tfvars"


terraform apply -auto-approve -destroy -var-file="local.tfvars"

this will help you
# https://developer.hashicorp.com/terraform/tutorials/applications/digitalocean-provider

you need to add your ssh key in to cloud init script
then add the same ssh key to your git actions secrets so that git actions can pretend that it is you
