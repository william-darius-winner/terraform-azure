output "namespace_name" {
  description = "Created namespace name"
  value       = kubernetes_namespace_v1.main.metadata[0].name
}
