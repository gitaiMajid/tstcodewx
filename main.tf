terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  description = "Name of the resource group that will host the storage account."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created."
  type        = string
  default     = "westeurope"
}

variable "storage_account_name" {
  description = "Globally unique name for the storage account (3-24 lowercase letters and numbers)."
  type        = string
}

variable "account_tier" {
  description = "The performance tier of the storage account."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication strategy for the storage account."
  type        = string
  default     = "LRS"
}

resource "azurerm_resource_group" "storage" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

output "storage_account_id" {
  description = "The resource ID of the created storage account."
  value       = azurerm_storage_account.storage.id
}

output "primary_connection_string" {
  description = "Primary connection string for the storage account."
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}
