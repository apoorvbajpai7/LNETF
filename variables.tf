// variables.tf
variable "location" {
  type    = string
  default = "East US"
}

variable "resource_group_name" {
  type = string
}

variable "subscription_id" {
  type    = string
  # Optionally specify a default value if applicable
  default = "9254a512-e00d-4bf0-9dcf-fe676789e34a"
}
// Define other variables as needed
