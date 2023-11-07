resource "azurerm_web_application_firewall_policy" "example" {
  name                = "waf-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = local.region

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  custom_rules {
    action    = "Allow"
    enabled   = true
    name      = "allowGary"
    priority  = 100
    rule_type = "MatchRule"

    match_conditions {
      match_values = [
        "bypass_owasp=1",
      ]
      negation_condition = false
      operator           = "Contains"
      transforms         = []

      match_variables {
        variable_name = "QueryString"
      }
    }
  }

  managed_rules {
    exclusion {
      match_variable          = "RequestHeaderNames"
      selector                = "my-secret-header"
      selector_match_operator = "Equals"
    }
    exclusion {
      match_variable          = "RequestCookieNames"
      selector                = "my-sweet-cookie"
      selector_match_operator = "EndsWith"
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920300"
          enabled = true
          action  = "Log"
        }

        rule {
          id      = "920440"
          enabled = true
          action  = "Block"
        }
      }
    }
  }
}
