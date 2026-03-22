provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "kubernetes" {
  host                   = module.aks.kube_config[0].host
  client_certificate     = base64decode(module.aks.kube_config[0].client_certificate)
  client_key             = base64decode(module.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config[0].cluster_ca_certificate)
}

# ─── Networking ───────────────────────────────────────────

module "networking" {
  source = "../../modules/networking"

  resource_group_name = "rg-platform-dev"
  location            = "centralus"
  project             = "platform"
  environment         = "dev"
  vnet_address_space  = "10.0.0.0/16"
  aks_subnet_prefix   = "10.0.0.0/22"

  tags = local.tags
}

# ─── AKS Cluster ──────────────────────────────────────────

module "aks" {
  source = "../../modules/aks"

  project             = "platform"
  environment         = "dev"
  location            = "centralus"
  resource_group_name = module.networking.resource_group_name
  subnet_id           = module.networking.aks_subnet_id
  kubernetes_version  = "1.31"

  # Cost-conscious dev settings
  vm_size              = "Standard_B2s"  # ~$30/month if running 24/7
  node_count           = 1
  auto_scaling_enabled = false
  sku_tier             = "Free"

  tags = local.tags
}

# ─── Container Registry ──────────────────────────────────

module "acr" {
  source = "../../modules/acr"

  registry_name           = "acrplatformdev${random_string.suffix.result}"
  resource_group_name     = module.networking.resource_group_name
  location                = "centralus"
  sku                     = "Basic"
  aks_kubelet_identity_id = module.aks.kubelet_identity_object_id

  tags = local.tags
}

# ─── Application Namespace ────────────────────────────────

module "app_namespace" {
  source = "../../modules/workload-namespace"

  namespace_name       = "sample-app"
  environment          = "dev"
  team_name            = "platform"
  cpu_request_limit    = "2"
  memory_request_limit = "2Gi"
  max_pods             = "20"
}

# ─── Supporting Resources ─────────────────────────────────

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  tags = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "platform-learning"
  }
}
