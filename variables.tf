variable "region" {
  description = "Enter the region"
  type        = string
  default     = "eu-gb"
}

variable "resource_group" {
  description = "Enter the name of Resource Group"
  type        = string
  default     = ""
}

variable prefix {
  description = "A unique identifier need to provision resources. Must begin with a letter"
  type        = string
  default     = "kgsch-vpcvsi-test1"

  validation {
    error_message = "Unique ID must begin with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
  }
}

variable "public_key" {
  description = "Enter the public SSH key"
  default     = ""
  sensitive   = true
}

variable "tags" {
  description = "A list of tags to be added to resources"
  type        = list(string)
  default     = ["kgsch-vpcvsi-test1", "vpc-vsi-prod"]
}

variable "zone1" {
  description = "Enter the zone of the subnet"
  type        = string
  default     = "eu-gb-1"
}

variable "create_timeout" {
  type        = string
  description = "Timeout duration for create."
  default     = "15m"
}




