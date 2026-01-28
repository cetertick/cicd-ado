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
    Clique em ADD Secret


A "metade" da nosa Pipeline (CI) está pronta:
 - Código alterado ➔ GitHub detecta.
 - Build e Teste ➔ GitHub Actions roda.
 - Pacote (Imagem) ➔ Salvo no Azure Container Registry (ACR).

Agora vamos montar a outra "metade" (CD) no Azure DevOps.
É aqui que vamos pegar esse pacote e fazer o deploy no Kubernetes.

 - Criar a Pipeline de Release
    Acesse seu projeto no dev.azure.com.

Passo 1: Criar o Projeto (O "Container" do trabalho)
Preencha o formulário da sua imagem assim:

Project name: Digite ToggleMaster-Aula.

Description: Pode deixar em branco.

Visibility: Mantenha Private (cadeado).

Clique no botão Create project.


Passo 2: Conectar o ADO com a Azure (Service Connection)
Agora que o projeto foi criado, você cairá na tela de "Summary" dele. Precisamos dar permissão para esse projeto mexer na sua conta Azure (onde está o Kubernetes).

Olhe para o canto inferior esquerdo da tela e clique na engrenagem ⚙️ Project settings.

Na coluna da esquerda, role para baixo até achar a seção Pipelines. Clique em Service connections.

Clique no botão azul Create service connection (no centro ou topo direito).

Selecione Azure Resource Manager e clique em Next.

Selecione Workload Identity federation (automatic) e clique em Next.

Nota: Como você está logado na mesma conta que criou a Azure, ele vai achar tudo sozinho.

Subscription: Aguarde carregar e selecione a sua assinatura (provavelmente "Azure subscription 1" ou "Free Trial").

Resource Group: Selecione rg-togglemaster-aula.

Service connection name: Digite ConexaoAzureAula.

Importante: Marque a caixinha Grant access permission to all pipelines.

Clique em Save.





Passo 3: Criar a Pipeline de Release
Agora vamos montar a esteira que pega o código do GitHub e joga no cluster.

No menu lateral esquerdo (volte para o menu principal se ainda estiver em Settings), clique em Pipelines ➔ Releases.

Clique em New pipeline.

Vai abrir uma gaveta lateral direita ("Select a template"). Clique em Empty job (o primeiro da lista).

Onde diz "Stage 1", mude o nome para Deploy Dev. Pode fechar a janelinha do estágio.

A. Definir de onde vem o código (Artifact)
Clique na caixa grande à esquerda onde diz Add an artifact.

Source type: Escolha GitHub (o ícone do gato).

Nota: Vai aparecer um botão Authorize. Clique nele e autorize o acesso à sua conta GitHub.

Depois de autorizado:

Repository: Digite ou selecione cetertick/cicd-ado.

Default branch: main.

Default version: Latest from default branch.

Clique em Add.

