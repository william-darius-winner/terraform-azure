variable "namespace_name" {
  description = "Kubernetes namespace name"
  type        = string
}

variable "environment" {
  description = "Environment identifier"
  type        = string
}

variable "team_name" {
  description = "Team that owns this namespace"
  type        = string
}

variable "cpu_request_limit" {
  description = "Total CPU request quota for the namespace"
  type        = string
  default     = "2"
}

variable "memory_request_limit" {
  description = "Total memory request quota for the namespace"
  type        = string
  default     = "2Gi"
}

variable "max_pods" {
  description = "Maximum number of pods in the namespace"
  type        = string
  default     = "20"
}
