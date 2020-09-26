module "elixir_cluster" {
    source = "github.com/fosk06/elixir-cluster-terraform-module"
    gcp_project_id = var.gcp_project_id
    gcp_region = var.gcp_region
    gcp_default_zone = var.gcp_default_zone
    vpc_name = var.vpc_name
    subnet_name = var.subnet_name
    subnet_cidr_range = var.subnet_cidr_range
    namespace_name = var.namespace_name
    service_name = var.service_name
    dns_managed_zone_name = var.dns_managed_zone_name
    dns_managed_zone_dns_name = var.dns_managed_zone_dns_name
    gcp_bucket_name = var.gcp_bucket_name
    image = var.image
    machine = var.machine
}

