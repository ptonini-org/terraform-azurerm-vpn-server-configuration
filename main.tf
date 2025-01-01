resource "azurerm_vpn_server_configuration" "this" {
  name                     = var.name
  vpn_authentication_types = var.authentication_types
  resource_group_name      = var.rg.name
  location                 = var.rg.location
  vpn_protocols            = var.vpn_protocols

  dynamic "client_root_certificate" {
    for_each = var.client_root_certificate
    content {
      name             = client_root_certificate.key
      public_cert_data = client_root_certificate.value
    }
  }

  dynamic "azure_active_directory_authentication" {
    for_each = var.aad_authentication[*]
    content {
      audience = azure_active_directory_authentication.value.audience
      issuer   = azure_active_directory_authentication.value.aad_authentication.issuer
      tenant   = azure_active_directory_authentication.value.aad_authentication.tenant
    }
  }
}

resource "azurerm_vpn_server_configuration_policy_group" "this" {
  for_each                    = var.policy_groups
  name                        = each.key
  vpn_server_configuration_id = azurerm_vpn_server_configuration.this.id

  dynamic "policy" {
    for_each = { for i, p in each.value.policies : i => p }
    content {
      name  = policy.value.name
      type  = policy.value.type
      value = policy.value.value
    }
  }
}