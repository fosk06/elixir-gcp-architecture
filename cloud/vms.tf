# locals {
#   release_url = "${module.elixir_cluster.bucket_url}/api-0.1.0.tar.gz"
#   startup_script_url = module.elixir_cluster.startup_script_url
#   shutdown_script_url = module.elixir_cluster.shutdown_script_url
#   secret_key_base = "bOweqFstyZamEyoS8FgijJAgXbny7xod3UeV+YmEuKeAfE1M901MDuIxvDu00dYl"
#   service_name = basename(module.elixir_cluster.service_name)
#   service_namespace = basename(module.elixir_cluster.service_namespace)
#   cluster_hostname = trimsuffix(module.elixir_cluster.dns_name,".")

#   # VM tags for firewall rules
#   tags = setunion(
#     module.elixir_cluster.http_network_tags,
#     module.elixir_cluster.https_network_tags,
#     module.elixir_cluster.epmd_network_tags
#   )
# }

# VM instances
# resource "google_compute_instance" "elixir-instance" {
#   project = var.gcp_project_id
#   count = var.total_instances // number of instances
#   name         = "elixir-instance-${count.index}"
#   machine_type = var.machine
#   zone         = var.gcp_default_zone
#   tags = local.tags

#   boot_disk {
#     initialize_params {
#       image = var.image
#       type = "pd-ssd"
#       size = var.ssd_size
#     }
#   }

#   network_interface {
#     network = module.elixir_cluster.vpc_link
#     subnetwork = module.elixir_cluster.subnet_link

#     access_config {

#     }
    
#   }

#   metadata = {
#     release-url = local.release_url
#     startup-script-url = local.startup_script_url
#     shutdown-script-url = local.shutdown_script_url
#     secret-key-base = local.secret_key_base
#     service-name = local.service_name
#     service-namespace = local.service_namespace
#     cluster-hostname = local.cluster_hostname
#     region = var.gcp_region
#   }

#   service_account {
#     email = module.elixir_cluster.service_account_email
#     scopes = ["userinfo-email","cloud-platform"]
#   }

#   scheduling {
#     preemptible = true
#     automatic_restart = false
#   }
# }

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

# # ------------------------------------------------------------------------------
# # CREATE TARGET POOL
# # ------------------------------------------------------------------------------

# resource "google_compute_target_pool" "default" {
#   provider         = google-beta
#   name             = "${var.name}-target-pool"
#   session_affinity = var.session_affinity
#   health_checks = [google_compute_http_health_check.default.self_link] # legacy health check
# }

# # ------------------------------------------------------------------------------
# # CREATE INSTANCE GROUP MANAGER
# # ------------------------------------------------------------------------------
# resource "google_compute_instance_group_manager" "default" {
#   name = "api-group-manager"

#   base_instance_name = "legacy-api"
#   zone = data.terraform_remote_state.lsd.outputs.default_zone

#   version {
#     instance_template = google_compute_instance_template.template.self_link
#   }
#   target_pools = [google_compute_target_pool.default.self_link]
#   auto_healing_policies {
#     health_check = google_compute_health_check.default.self_link
#     initial_delay_sec = 300
#   }
  
#   named_port {
#     name = "http"
#     port = 80
#   }

#   depends_on = [null_resource.api_v1_backend_service, google_compute_instance_template.template]
# }

# # ------------------------------------------------------------------------------
# # CREATE AUTOSCALER
# # ------------------------------------------------------------------------------

# resource "google_compute_autoscaler" "default" {
#   provider = google-beta
#   name   = "${var.name}-autoscaler"
#   zone   = data.terraform_remote_state.lsd.outputs.default_zone
#   target = google_compute_instance_group_manager.default.id

#   autoscaling_policy {
#     min_replicas    = 2
#     max_replicas    = 10
#     cooldown_period = 60

#     cpu_utilization {
#       target = 0.6
#     }

#     load_balancing_utilization {
#         target = 0.8
#     }
    
#   }
# }