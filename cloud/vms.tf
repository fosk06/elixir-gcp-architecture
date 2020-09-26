locals {
  release_url = "${module.elixir_cluster.bucket_url}/api-0.1.0.tar.gz"
  startup_script_url = module.elixir_cluster.startup_script_url
  shutdown_script_url = module.elixir_cluster.shutdown_script_url
  secret_key_base = "bOweqFstyZamEyoS8FgijJAgXbny7xod3UeV+YmEuKeAfE1M901MDuIxvDu00dYl"
  service_name = basename(module.elixir_cluster.service_name)
  service_namespace = basename(module.elixir_cluster.service_namespace)
  cluster_hostname = trimsuffix(module.elixir_cluster.dns_name,".")

  # VM tags for firewall rules
  tags = setunion(
    module.elixir_cluster.http_network_tags,
    module.elixir_cluster.https_network_tags,
    module.elixir_cluster.epmd_network_tags
  )
}

# VM instances
resource "google_compute_instance" "elixir-instance" {
  project = var.gcp_project_id
  count = var.total_instances // number of instances
  name         = "elixir-instance-${count.index}"
  machine_type = var.machine
  zone         = var.gcp_default_zone
  tags = local.tags

  boot_disk {
    initialize_params {
      image = var.image
      type = "pd-ssd"
      size = var.ssd_size
    }
  }

  network_interface {
    network = module.elixir_cluster.vpc_link
    subnetwork = module.elixir_cluster.subnet_link

    access_config {

    }
    
  }

  metadata = {
    release-url = local.release_url
    startup-script-url = local.startup_script_url
    shutdown-script-url = local.shutdown_script_url
    secret-key-base = local.secret_key_base
    service-name = local.service_name
    service-namespace = local.service_namespace
    cluster-hostname = local.cluster_hostname
    region = var.gcp_region
  }

  service_account {
    email = module.elixir_cluster.service_account_email
    scopes = ["userinfo-email","cloud-platform"]
  }

  scheduling {
    preemptible = true
    automatic_restart = false
  }
}