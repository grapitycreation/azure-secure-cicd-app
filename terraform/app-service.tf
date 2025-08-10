# --- Nền tảng của ứng dụng web ---

# 1. Tạo App Service Plan
resource "azurerm_service_plan" "app_plan" {
  name                = "plan-secureapp"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1" # Bắt buộc dùng gói B1 trở lên để có VNet Integration

  tags = {
    project = "Secure Web App CI/CD"
    owner   = "Tran Huu Hieu"
  }
}

# 2. Tạo App Service
resource "azurerm_linux_web_app" "web_app" {
  # Sử dụng tên động để đảm bảo duy nhất
  name                = "app-secureapp-${random_pet.app_name_suffix.id}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_plan.id

  # **QUAN TRỌNG: Thêm lại VNet Integration**
  virtual_network_subnet_id = azurerm_subnet.appservice_subnet.id

  site_config {
    application_stack {
      python_version = "3.9"
    }
    always_on = false
  }
  
  # Cài đặt để traffic chỉ có thể đến từ VNet
  https_only = true
  
  tags = {
    project = "Secure Web App CI/CD"
    owner   = "Tran Huu Hieu"
  }
}