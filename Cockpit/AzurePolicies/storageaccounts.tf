data "azurerm_subscription" "currentsa" {}

resource "azurerm_policy_definition" "SApolicies" {
  name         = "my-policy-definitionSA"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "saacctestpol-%d"
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
  name                 = "example-policy-assignmentSA"
  scope                = "${azurerm_resource_group.test.id}"
  policy_definition_id = "${azurerm_policy_definition.SApolicies.id}"
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Acceptance Test RunSA"
}