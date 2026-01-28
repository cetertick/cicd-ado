CICD - Github Action e Azure DevOps (ADO)

PREMISSAS
- Subscription na Azure
- Terraform

Com isso em mãos, vamos levantar a infraestrutura.

Criando a Infraestrutura (Terraform)
- Insira os dois arquivos listados abaixo:
  - provider.tf
  - main.tf

O arquivo provider.tf diz ao terraform qual provedor CLOUD usaremos. Para este LAB, a Azure.
No arquivo main.tf temos a instrução que cria o ACR (para guardar as imagens Docker) e o AKS (o cluster Kubernetes).

OBS: O nome utilizado no ACR precisa ser único no mundo todo.
