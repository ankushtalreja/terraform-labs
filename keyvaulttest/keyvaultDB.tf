
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "testkvrg" {
  name     = "my-resource-group"
  location = "West US"
}

resource "random_id" "server" {
  keepers = {
    ami_id = 1
  }
  byte_length = 8
}

resource "azurerm_key_vault" "test" {
  name                = "${format("%s%s", "kv", random_id.server.hex)}"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  tenant_id           = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "8acfae95-74e8-4ad0-84f6-8d9e1eaf1e43"

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
    ]
  }

  tags {
    environment = "Production"
  }
}

resource "azurerm_key_vault_secret" "test" {
  name      = "DBpass"
  value     = "Welcome12345"
  vault_uri = "${azurerm_key_vault.test.vault_uri}"

  tags {
    environment = "Production"
  }
}
data "azurerm_key_vault_secret" "testsec" {
  name      = "DBpass"
 vault_uri = "${azurerm_key_vault.test.vault_uri}"
 
}


resource "azurerm_resource_group" "test" {
  name     = "acceptanceTestResourceGroup1"
  location = "West US"
}


resource "azurerm_sql_server" "test" {
    name = "mysqlserver3425"
    resource_group_name = "${azurerm_resource_group.test.name}"
    location = "West US"
    version = "12.0"
    administrator_login = "ankush"
    administrator_login_password = "${data.azurerm_key_vault_secret.testsec.value}"
    
}

resource "azurerm_sql_database" "test" {
  name                = "mysqldatabase12342"
  resource_group_name = "${azurerm_resource_group.test.name}"
    location = "West US"
    server_name = "${azurerm_sql_server.test.name}"
    

  tags {
    environment = "production"
  }
}