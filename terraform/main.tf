resource "azurerm_resource_group" "main" {
  name     = "rg-devops-academia"
  location = "eastus"

  tags = {
    environment = "learning"
    project     = "devops-academia"
    team        = "devops"
  }
}
