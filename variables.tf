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
  default = "YOUR_SUBSCRIPTION_ID_HERE"
}
// Define other variables as needed
