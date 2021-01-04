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