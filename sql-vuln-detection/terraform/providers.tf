terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }
  required_version = ">= 1.2.0"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}