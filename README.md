# portfolio-v2


# Terrafrom apply commands
export $(cat .env | xargs) # Refresh variables
terraform apply -auto-approve -var "digitalocean_token=$DO_TOKEN"


terraform apply -auto-approve -destroy -var "digitalocean_token=$DO_TOKEN"

