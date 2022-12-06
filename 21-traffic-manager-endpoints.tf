# Virtual Hubs
resource "azurerm_traffic_manager_azure_endpoint" "traffic_manager_endpoint" {
  for_each = var.traffic_manager_endpoints

  dynamic "custom_header" {
    for_each = lookup(var.traffic_manager_endpoint_custom_headers, each.key, null) != null ? lookup(var.traffic_manager_endpoint_custom_headers, each.key, null) : []
    content {
      name  = custom_header.value["name"]
      value = custom_header.value["value"]
    }
  }
  enabled             = lookup(each.value, "endpoint_status", null)
  geo_mappings        = lookup(each.value, "geo_mappings", null) != null ? split(",", replace(lookup(each.value, "geo_mappings", ""), " ", "")) : null
  name                = each.key
  priority            = lookup(each.value, "priority", null)
  profile_id          = azurerm_traffic_manager_profile.traffic_manager_profile.*.id
  dynamic "subnet" {
    for_each = lookup(var.traffic_manager_endpoint_subnets, each.key, null) != null ? lookup(var.traffic_manager_endpoint_subnets, each.key, null) : []
    content {
      first = subnet.value["first"]
      last  = subnet.value["last"]
      scope = subnet.value["scope"]
    }
  }
  target_resource_id = lookup(each.value, "target_resource_id", null)
  weight             = lookup(each.value, "weight", null)

  depends_on = [
    azurerm_traffic_manager_profile.traffic_manager_profile
  ]
}
