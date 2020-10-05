/*
  Project wide variables
*/

################ Global configuration #################################################

variable "gcp_project_id" {
  description = "gcp project id"
  default = "prestashop-data-integration"
}

variable "gcp_region" {
  description = "Where the cluster will live"
  default = "europe-west1"
}

variable "gcp_default_zone" {
  description = "GCP default zone"
  default = "europe-west1-c"
}



################ Network #################################################

variable "vpc_name" {
  type        = string
  description = "name of the vpc"
  default = "ex-vpc"
}

variable "subnet_name" {
  type        = string
  description = "name of the subnet"
  default = "ex-subnet"
}

variable "subnet_cidr_range" {
  type        = string
  description = "ip range of subnetwork"
  default = "10.2.0.0/16"
}

################ Service directory #################################################

variable "namespace_name" {
  type        = string
  description = "name of the service directory namespace"
  default = "mycompany"
}

variable "service_name" {
  type        = string
  description = "name of the service  directory service"
  default = "api"
}

variable "dns_managed_zone_name" {
  type        = string
  description = "name of the dns managed zone"
  default = "mycompany-app"
}

variable "dns_managed_zone_dns_name" {
  type        = string
  description = "dns hostname record like myapp.com. "
  default = "mycompany.app."
}

################ Storage #################################################

variable "gcp_bucket_name" {
  type        = string
  description = "name of gcp bucket"
  default = "elixir_build_artifacts"
}



################ Virtual machines ########################################

variable "image" {
  default     = "debian-cloud/debian-10"
  description = "kind of the image for the vm"
}

variable "machine_type" {
  type        = string
  description = "Machine type to use for APIs"
  default = "n1-standard-1"
}

variable "disk_type" {
  type        = string
  description = "size of the disk"
  default = "pd-ssd"
}

variable "disk_size" {
  type        = number
  description = "size of the disk"
  default =350
}

variable "vm_preemptible" {
  type        = bool
  description = "are vm preamtible"
  default = true
}

variable "release_url" {
  type        = string
  description = "release of the URL"
  default = "gs://elixir_build_artifacts/api-0.1.0.tar.gz"
}

variable "secret_key_base" {
  type        = string
  description = "secret key to deploy and run elixir application"
  default = "bOweqFstyZamEyoS8FgijJAgXbny7xod3UeV+YmEuKeAfE1M901MDuIxvDu00dYl"
}

variable default_autoscaler {
  type        = bool
  description = "create default autoscaler or not"
  default = false
}

variable default_autoscaler_target_cpu {
  type        = number
  description = "target CPU to scale up the cluster"
  default = 0.7
}

variable autoscaler_min_replicas {
  type        = number
  description = "minimum number of vm in the pool"
  default = 2
}

variable autoscaler_max_replicas {
  type        = number
  description = "maximum number of vm in the pool"
  default = 5
}

variable autoscaler_cooldown_period {
  type        = number
  description = "time to wait for VM availability"
  default = 30
}

variable "node_distribution_port" {
  type        = string
  description = "erlang node distribution port"
  default = "9999"
}