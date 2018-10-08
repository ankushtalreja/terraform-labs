data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "vnetsubpolicies" {
  name         = "my-policy-definition"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "acctestpol-%d"
  policy_rule  = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
    {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS
}

resource "azurerm_resource_group" "test" {
  name = "test-resources"
  location = "West Europe"
}

resource "azurerm_policy_assignment" "test" {
  name                 = "example-policy-assignment"
  scope                = "${azurerm_resource_group.test.id}"
  policy_definition_id = "${azurerm_policy_definition.vnetsubpolicies.id}"
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Acceptance Test Run %d"
  parameters = <<PARAMETERS
{
  "allowedLocations": {
    "value": ["${var.Deployloc}"]
  }
}
PARAMETERS
}