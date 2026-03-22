variable "registry_name" {
  description = "Container registry name (globally unique, alphanumeric only)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{5,50}$", var.registry_name))
    error_message = "Registry name must be 5-50 alphanumeric characters."
  }
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "ACR SKU: Basic, Standard, or Premium"
  type        = string
  default     = "Basic"
}

variable "aks_kubelet_identity_id" {
  description = "Object ID of the AKS kubelet managed identity"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
