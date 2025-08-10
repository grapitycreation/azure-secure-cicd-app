# Tạo một chuỗi ngẫu nhiên để đảm bảo tên App Service là duy nhất trên toàn cầu
resource "random_pet" "app_name_suffix" {
  length = 2
}