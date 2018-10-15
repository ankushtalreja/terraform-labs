
/*This tf will create an Azure Policy definition to deny deployment of storage account which 
does not have HTTPS flag enabled and assign it to currently logged in or SET subscription.

*/
data "azurerm_subscription" "currentsa" {}

resource "azurerm_policy_definition" "SApolicies" {
  name         = "${var.PolicyDefName}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "${var.PolicyDefName}"
  policy_rule  = <<POLICY_RULE
 {
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Storage/storageAccounts"
      },
      {
        "not": {
          "field": "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
          "equals": "True"
        }
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}

  


resource "azurerm_policy_assignment" "testsa" {
  name                 = "${var.PolicyAssignmentName}"
  scope                = "${azurerm_resource_group.test.id}"
  policy_definition_id = "${azurerm_policy_definition.SApolicies.id}"
  description          = "Assignment of policy definition to deny deployment of storage accounts without HTTPS enabled"
  display_name         = "${var.PolicyAssignmentName}"
}