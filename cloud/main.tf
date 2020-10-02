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
    machine_type = var.machine_type
    disk_type = var.disk_type
    disk_size = var.disk_size
    vm_preemptible = var.vm_preemptible

}

# ------------------------------------------------------------------------------
# CREATE VM TEMPLATE
# ------------------------------------------------------------------------------
# variable GIT_URL {}


# resource "google_compute_instance_template" "template" {
#   name_prefix  = "api-v2"
#   machine_type = "n1-standard-2"
#   tags = var.firewall_target_tags
#   labels = {
#     environment = "production"
#     langage = "nodejs"
#   }
#   instance_description = "VM hosting the deprecated prestashop api"
#   can_ip_forward = true

#   scheduling {
#     automatic_restart   = true
#     on_host_maintenance = "MIGRATE"
#   }
#   disk {
#     source_image = "family/nodejs" # custom image deployed with packer, see "nodejs-14.json" packer file
#     auto_delete  = true
#     boot         = true
#   }

#   network_interface {
#     network = "default"
#     access_config {
#         network_tier = "PREMIUM"
#     }
#   }
  
#   lifecycle {
#     create_before_destroy = true
#   }

#   metadata = {
#     GIT_URL = var.GIT_URL # used to clone the git project on the VM by the startup.js script
#     PORT = var.api_port # port of  the API
#     NODE_ENV = "production"
#     GIT_BRANCH = terraform.workspace == "production" ?  "master" : "staging" # set the git branch
#   }

#   service_account {
#     email = "api-v2-storage@prestashop-data-${terraform.workspace}.iam.gserviceaccount.com"
#     scopes = [
#       "https://www.googleapis.com/auth/cloud-platform",
#       "https://www.googleapis.com/auth/logging.write"
#     ]
#   }
  
#   # run the nodejs application
#   metadata_startup_script = "/home/node/scripts/startup.js"
  
# }