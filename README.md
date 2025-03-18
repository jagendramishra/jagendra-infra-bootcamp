# jagendra-infra-bootcamp
AKS cluster using terraform

First create a backend for terraform state persistence.

Export these vars in command line

RESOURCE_GROUP_NAME="jagendra-infra-bootcamp" #predefined value
STORAGE_ACCOUNT_NAME="tfstateaksstoragejag"
CONTAINER_NAME="tfstate"

export ARM_CLIENT_ID="<APP_ID>"
export ARM_CLIENT_SECRET="<PASSWORD>"
export ARM_TENANT_ID="<TENANT_ID>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"

az login using below command in your cli

az login --service-principal \
  --username ************** \
  --password ************** \
  --tenant **************

# Create Resource Group - already created
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create Storage Account
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group jagendra-infra-bootcamp --sku Standard_LRS

# Create Container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

STORAGE_ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)

terraform fmt

terraform validate

terraform plan

terraform apply

Fetch cluster in cli-

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name "aks-cluster"

