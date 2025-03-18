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

keyvault permission since RABC is not enabled. TBD-

az keyvault set-policy \
  --name aks-keyvault-jag \
  --spn 72b1f2e8-5897-4b77-b4f7-0670ce8d7869 \
  --secret-permissions get list

az keyvault set-policy \
  --name aks-keyvault-jag \
  --spn 72b1f2e8-5897-4b77-b4f7-0670ce8d7869 \
  --secret-permissions get list set delete



az keyvault show --name aks-keyvault-jag --query "properties.accessPolicies"

Fetch db password using
az keyvault secret show --vault-name aks-keyvault-jag --name postgres-password-jag

Install ingress-nginx and other services-

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace


helm repo add elastic https://helm.elastic.co
helm repo update

helm install elasticsearch elastic/elasticsearch \
  --namespace elastic-system --create-namespace

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install grafana grafana/grafana \
  --namespace grafana-system --create-namespace \
  --set service.type=ClusterIP

configure grafana

kubectl get secret --namespace grafana-system grafana -o jsonpath="{.data.admin-password}" | base64 --decode


128.251.111.115 externalip


az network lb list --resource-group $RESOURCE_GROUP_NAME  --output table

check if port 80 is allowed


az network nsg rule list \
  --resource-group $RESOURCE_GROUP_NAME \
  --nsg-name <nsg-name> \
  --output table

az network watcher connectivity-check \
  --source-resource 192.168.1.38 \
  --destination-address 128.251.111.115 \
  --destination-port 80


az network watcher configure --resource-group $RESOURCE_GROUP_NAME --locations northeurope --enabled true


grafana- connnection

aks-postgres-server.postgres.database.azure.com

psql "host=aks-postgres-server.postgres.database.azure.com \
      port=5432 \
      dbname=exampledb \
      user=adminuser@aks-postgres-server \
      password=********** \
      sslmode=require"

az postgres server show --name aks-postgres-server --resource-group $RESOURCE_GROUP_NAME

az postgres server show --id aks-postgres-server --resource-group $RESOURCE_GROUP_NAME

az postgres server firewall-rule list --server-name aks-postgres-server --resource-group $RESOURCE_GROUP_NAME


add ip to azure firewall


az postgres server firewall-rule create \
  --resource-group $RESOURCE_GROUP_NAME \
  --server-name aks-postgres-server \
  --name AllowMyIP \
  --start-ip-address 192.168.1.38 \
  --end-ip-address 192.168.1.38


az postgres server firewall-rule list \
  --resource-group $RESOURCE_GROUP_NAME \
  --server-name aks-postgres-server
