variable "storage_account_name" {
  description = "Variable name default"
  type        = string
  default     = "Private_Storage_ME"
}

variable "location" {
  description = "Variable that indicates the region where the will be created"
  type        = string
  default     = "Brazil South"
}

variable "account_tier" {
  description = "Storage Account Tier on Azure"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage Account Data Replication Type"
  type        = string
  default     = "LRS"
  sensitive   = true
}