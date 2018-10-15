
/*This tf will create an Azure Policy definition to deny deployment of all the azure resource type 
except ExpressRoute Circuit & Storage Account and assign it to currently logged in or SET subscription.

*/
data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "ERresourcepolicy" {
  name         = "${var.PolicyDefName}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "${var.PolicyDefName}"
  policy_rule  = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "type",
        "in": "[parameters('allowedResources')]"
      }
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
    {
    "allowedResources": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed resources.",
        "displayName": "allowedResources",
        "strongType": "Resources"
      }
    }
  }
PARAMETERS

 

}

resource "azurerm_resource_group" "tester" {
  name = "test-respolicy"
  location = "West Europe"
}

resource "azurerm_policy_assignment" "ERpolicyassignment" {
  name                 = "${var.PolicyAssignmentName}"
  scope                = "${azurerm_resource_group.tester.id}"
  policy_definition_id = "${azurerm_policy_definition.ERresourcepolicy.id}"
  description          = "Assignment of policy definition to deny deployment of all the azure resource type except ExpressRoute Circuit and storage acount"
  display_name         = "${var.PolicyAssignmentName}"

  parameters = <<PARAMETERS
{
  "allowedResources": {
    "value": [ "Microsoft.Storage/storageAccounts", "Microsoft.Network/expressRouteCircuits" ]
  }
}
PARAMETERS
}

