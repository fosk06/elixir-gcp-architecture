# output "release_url" {
#   value       = local.release_url
#   description = "release_url"
# }

# output "startup_script" {
#   value       = local.startup_script_url
#   description = "startup_script"
# }

# output "shutdown_script" {
#   value       = local.shutdown_script_url
#   description = "shutdown_script"
# }

# output "service_name" {
#   value       = local.service_name
#   description = "service_name"
# }

# output "service_namespace" {
#   value       = local.service_namespace
#   description = "service_namespace"
# }

# output "dns_name" {
#   value       = local.cluster_hostname
#   description = "dns_name"
# }

# output "network_tags" {
#   value       = local.tags
#   description = "network_tags"
# }


output "bucket_url" {
  value       = module.elixir_cluster.bucket_url
  description = "bucket url"
}

output "startup_script_url" {
  value       = module.elixir_cluster.startup_script_url
  description = "startup script url"
}

output "shutdown_script_url" {
  value       = module.elixir_cluster.shutdown_script_url
  description = "shutdown script url"
}

output "vpc_link" {
  value       = module.elixir_cluster.vpc_link
  description = "vpc link"
}

output "subnet_link" {
  value       = module.elixir_cluster.subnet_link
  description = "subnet_link"
}

output "service_account_email" {
  value       = module.elixir_cluster.service_account_email
  description = "service_account_email"
}


output "service_namespace" {
  description = "The GCP service directory namespace name"
  value       = module.elixir_cluster.service_namespace
}

output "service_name" {
  description = "The private hostname where apps will be available (DNS A record)"
  value       = module.elixir_cluster.service_name
}

output "dns_name" {
  description = "The private hostname where apps will be available (DNS A record)"
  value       = module.elixir_cluster.dns_name
}