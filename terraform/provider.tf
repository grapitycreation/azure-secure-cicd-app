#Cấu hình các "provider" mà Terraform sẽ sử dụng
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

#Cấu hình chi tiết cho provider azurerm
# Terraform sẽ tự động sử dụng thông tin đăng nhập từ Azure CLI mà bạn đã chạy 'az login'
provider "azurerm" {
  features {}
  skip_provider_registration = true
}
