
variable "meta" {
  description = "Application meta, which contains tags, environment or application name"
  default     = {}
}

## Networking Service
variable "networking_module" {
  description = "Networking service aims to hold data related with networking services"
  default     = {}
}

## Apps
variable "app_config" {
  description = "App Config aims to hold data related with will be provisioned apps"
  default     = {}
}
