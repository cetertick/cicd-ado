CICD - Github Action e Azure DevOps (ADO)

PREMISSAS
- Subscription na Azure
- Terraform

Com isso em mãos, vamos levantar a infraestrutura.

Criar a Infraestrutura na Azure (Terraform)
- Insira os dois arquivos listados abaixo:
  - provider.tf
  - main.tf

O arquivo provider.tf diz ao terraform qual provedor CLOUD usaremos. Para este LAB, a Azure.
No arquivo main.tf temos a instrução que cria o ACR (para guardar as imagens Docker) e o AKS (o cluster Kubernetes).

OBS: O nome utilizado no ACR precisa ser único no mundo todo.


Executando o Terraform (Mão na Massa)
Abra o terminal do VS Code (Ctrl + '), entre na pasta e rode os comandos:

terraform init
    - inicializa o provider

terraform plan
    - planeja a utilização dos recursos

terraform apply -auto-approve
    - Aplica (cria de verdade) os recursos


PREPARANDO A APLICAÇÃO

Os arquivos da aplicação estão em SRC/AUTH

Comitar tudo para o REPO


PREPARANDO O ACTIONS
 - Login do Github com a Azure para o Actions

    - Pegar o ID da Assinatura 
        az account show --query id --output tsv

    - Gerar a Credencial
        az ad sp create-for-rbac --name "github-actions-fix" --role contributor --scopes /subscriptions/SEU_ID_AQUI --sdk-auth

O terminal vai gerar um output similar:
{
  "clientId": "xxxx...",
  "clientSecret": "xxxx...",
  "subscriptionId": "xxxx...",
  "tenantId": "xxxx...",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}

    - Atualizar no GitHub

    Vá no seu repositório no GitHub
    Settings -> Secrets and variables -> Actions
    Crie a secret AZURE_CREDENTIALS (Repository Secrets)
    Name: AZURE_CREDENTIALS
    Value: Cole o JSON limpo que você copiou (somente de { até })
    Clique em Create ADD Secret

    