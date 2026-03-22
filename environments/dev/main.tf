provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}



module "networking" {
  source = "../../modules/networking"

  tags = local.tags
}

module "aks" {
  source = "../../modules/aks"

  tags = local.tags
}

module "acr" {
  source = "../../modules/acr"

  tags = local.tags
}

module "app_namespace" {
  source = "../../modules/workload-namespace"

}



locals {
  tags = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "terraform-azure"
  }
}
