# General
variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "Target Azure location to deploy the resource."
  type        = string
  default     = "UK South"
}

variable "resource_group_name" {
  description = "Enter Resource Group name."
  type        = string
  default     = null
}

# Traffic Manager Endpoints
variable "traffic_manager_endpoints" {
  type    = map(map(any))
  default = {}
}

variable "traffic_manager_endpoint_custom_headers" {
  type    = map(list(map(string)))
  default = {}
}

variable "traffic_manager_endpoint_subnets" {
  type    = map(list(map(string)))
  default = {}
}

# Traffic Manager Profiles
variable "traffic_manager_profiles" {
  type    = map(list(map(any)))
  default = {}
}

variable "traffic_manager_profile_custom_headers" {
  type    = map(list(map(string)))
  default = {}
}
