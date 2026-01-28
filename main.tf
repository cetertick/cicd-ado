resource "azurerm_resource_group" "rg" {
  name     = "rg-togglemaster-aula"
  location = "East US"
}

# 1. Registry
resource "azurerm_container_registry" "acr" {
  name                = "acraulatogglemaster"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 2. Cluster Kubernetes
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-togglemaster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "togglemaster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }
}

# 3. Permissão para o AKS baixar imagens do ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}