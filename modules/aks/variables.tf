variable "project" {
  description = "Project name used in resource naming"
  type        = string
}

variable "environment" {
  description = "Environment identifier"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy into"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for AKS nodes"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version — check: az aks get-versions -l centralus"
  type        = string
  default     = "1.31"
}

variable "sku_tier" {
  description = "AKS SKU tier: Free (no SLA), Standard (SLA), Premium (LTS)"
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "SKU tier must be Free, Standard, or Premium."
  }
}

variable "vm_size" {
  description = "VM size for node pool"
  type        = string
  default     = "Standard_B2s"
}

variable "node_count" {
  description = "Static node count when autoscaling is disabled"
  type        = number
  default     = 1
}

variable "auto_scaling_enabled" {
  description = "Enable cluster autoscaler"
  type        = bool
  default     = false
}

variable "node_min" {
  description = "Min nodes when autoscaling enabled"
  type        = number
  default     = 1
}

variable "node_max" {
  description = "Max nodes when autoscaling enabled"
  type        = number
  default     = 3
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "172.16.0.0/16"
}

variable "dns_service_ip" {
  description = "IP for Kubernetes DNS (must be within service_cidr)"
  type        = string
  default     = "172.16.0.10"
}

variable "pod_cidr" {
  description = "CIDR for pod IPs (required for overlay mode)"
  type        = string
  default     = "10.244.0.0/16"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
