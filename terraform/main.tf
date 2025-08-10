#Tạo một Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project = "Secure Web App CI/CD"
    owner   = "Tran Huu Hieu"
  }
}

# --- Mạng ảo và các mạng con ---
# 1. Tạo một mảng ảo (Virtual Network)
resource "azurerm_virtual_network" "vnet" {
  name = "vnet-secureapp"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  address_space = ["10.0.0.0/16"]

  tags = {
    project = "Secure Web App CI/CD"
    owner = "Tran Huu Hieu"
  }
}

# 2. Tạo một Subnet dành riêng cho Application Gateway
resource "azurerm_subnet" "appgateway_subnet" {
  name = "snet-appgateway"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.1.0/24"]
}

# 3. Tạo một Subnet dành riêng cho App Service
resource "azurerm_subnet" "appservice_subnet" {
  name = "snet-appservice"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.2.0/24"]

  # Cấu hình đặc biệt để App Service có thể tích hợp vào Subnet này
  delegation {
    name = "appservice-delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

## --- Cổng bảo vệ Application Gateway và WAF ---

# 1. Tạo một địa chỉ IP Public cho Application Gateway
# Đây là địa chỉ mà người dùng sẽ truy cập từ Internet
resource "azurerm_public_ip" "appgateway_pip" {
  name = "pip-appgateway"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
  zones = ["1"]
}

# 2. Tạo Application Gateway
resource "azurerm_application_gateway" "app_gateway" {
  name = "appgw-secureapp"
  resource_group_name = var.resource_group_name
  location = var.location

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
    capacity = 2
  }
  
  waf_configuration {
    enabled = true
    firewall_mode = "Prevention"
    rule_set_type = "OWASP"
    rule_set_version = "3.2"
  }

  # --- cấu hình mạng cho Gateway ---

  # A. Cấu hình IP Frontend (nơi Gateway nhận traffic)
  frontend_ip_configuration {
    name = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.appgateway_pip.id
  }

  # B. Cấu hình Subnet cho Gateway
  gateway_ip_configuration {
    name = "gateway-ip-config"
    subnet_id = azurerm_subnet.appgateway_subnet.id
  }

  # --- Cấu hình định tuyến (Routing) ---

  # C. Backend Pool (Nơi Gate way sẽ đẩy traffic tới)
  backend_address_pool {
    name = "backend-pool-appservice"
    fqdns = [azurerm_linux_web_app.web_app.default_hostname]
  }

  # HTTP Listener
  # Lắng nghe các yêu cầu HTTP trên cổng 80
  frontend_port {
    name = "http-port"
    port = 80
  }

  http_listener {
    name = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name = "http-port"
    protocol = "Http"
  }

  # D. Health Probe
  # Kiểm tra sức khỏe của App Service
  probe {
    name = "health-probe-appservice"
    protocol = "Http"
    host = azurerm_linux_web_app.web_app.default_hostname
    path = "/"
    interval = 30
    timeout = 20
    unhealthy_threshold = 3
  }

  # E. Request Routing Rule
  request_routing_rule {
    name = "routing-rule-http"
    rule_type = "Basic"
    priority = 100
    http_listener_name = "http-listener"
    backend_address_pool_name = "backend-pool-appservice"
    backend_http_settings_name = "http-settings"
  }

  # Cài đặt cho các kết nối từ Gateway tới Backend
  backend_http_settings {
    name = "http-settings"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 20
    probe_name = "health-probe-appservice"
    host_name = azurerm_linux_web_app.web_app.default_hostname
  }

  tags = {
    project = "Secure Web App CI/CD"
    owner = "Tran Huu Hieu"
  }

}