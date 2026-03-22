resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.project}-${var.environment}"
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  # Auto-upgrade to latest stable patch
  automatic_upgrade_channel = "stable"
  node_os_channel_upgrade   = "NodeImage"

  # Managed identity — no credential rotation needed
  identity {
    type = "SystemAssigned"
  }

  # Workload identity for pod-to-Azure auth
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # RBAC
  role_based_access_control_enabled = true

  default_node_pool {
    name                   = "system"
    vm_size                = var.vm_size
    os_disk_size_gb        = 30
    vnet_subnet_id         = var.subnet_id
    auto_scaling_enabled   = var.auto_scaling_enabled  # 4.x renamed
    min_count              = var.auto_scaling_enabled ? var.node_min : null
    max_count              = var.auto_scaling_enabled ? var.node_max : null
    node_count             = var.auto_scaling_enabled ? null : var.node_count
    node_public_ip_enabled = false                     # 4.x renamed

    # Required for node pool VM size changes without downtime
    temporary_name_for_rotation = "temp"

    upgrade_settings {
      max_surge = "33%"
    }

    tags = var.tags
  }

  # Azure CNI Overlay + Cilium
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "cilium"
    network_data_plane  = "cilium"
    load_balancer_sku   = "standard"
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    pod_cidr            = var.pod_cidr
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count, # Autoscaler manages this
    ]
  }
}
