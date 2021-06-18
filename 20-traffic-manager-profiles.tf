resource "azurerm_traffic_manager_profile" "traffic_manager_profile" {
  for_each = var.traffic_manager_profiles

  dynamic "dns_config" {
    for_each = lookup(each.value, "relative_name", null) != null && lookup(each.value, "ttl", null) != null ? [1] : []
    content {
      relative_name = lookup(each.value, "relative_name", null)
      ttl           = lookup(each.value, "ttl", null)
    }
  }
  max_return = lookup(each.value, "max_return", null)
  dynamic "monitor_config" {
    for_each = lookup(each.value, "protocol", null) != null && lookup(each.value, "port", null) != null ? [1] : []
    content {
      dynamic "custom_header" {
        for_each = lookup(var.traffic_manager_profile_custom_headers, each.key, null) != null ? lookup(var.traffic_manager_profile_custom_headers, each.key, null) : []
        content {
          name  = custom_header.value["name"]
          value = custom_header.value["value"]
        }
      }
      expected_status_code_ranges  = lookup(each.value, "expected_status_code_ranges", null) != null ? split(",", replace(lookup(each.value, "expected_status_code_ranges", ""), " ", "")) : null
      interval_in_seconds          = lookup(each.value, "interval_in_seconds", null)
      path                         = lookup(each.value, "path", null)
      port                         = lookup(each.value, "port", null)
      protocol                     = lookup(each.value, "protocol", null)
      timeout_in_seconds           = lookup(each.value, "timeout_in_seconds", null)
      tolerated_number_of_failures = lookup(each.value, "tolerated_number_of_failures", null)
    }
  }
  name                   = each.key
  profile_status         = lookup(each.value, "profile_status", null)
  resource_group_name    = lookup(each.value, "resource_group_name", azurerm_resource_group.traffic_manager_resource_group[0].name)
  traffic_routing_method = lookup(each.value, "traffic_routing_method", null)
  traffic_view_enabled   = lookup(each.value, "traffic_view_enabled", null)

  tags = var.common_tags
}
