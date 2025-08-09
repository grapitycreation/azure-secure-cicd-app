variable "resource_group_name" {
  description = "Tên của Resource Group chứa tất cả các tài nguyên"
  type        = string
  default = "rg-secureapp-project"
}

variable "location" {
  description = "Vị trí địa lý của tài nguyên trên Azure"
  type        = string
  default     = "Southeast Asia"
}