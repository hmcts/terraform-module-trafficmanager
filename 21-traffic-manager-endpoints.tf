# Virtual Hubs
resource "azurerm_traffic_manager_endpoint" "traffic_manager_endpoint" {
  for_each = var.traffic_manager_endpoints

  dynamic "custom_header" {
    for_each = lookup(var.traffic_manager_endpoint_custom_headers, each.key, null) != null ? lookup(var.traffic_manager_endpoint_custom_headers, each.key, null) : []
    content {
      name  = custom_header.value["name"]
      value = custom_header.value["value"]
    }
  }
  endpoint_location   = lookup(each.value, "endpoint_location", null)
  endpoint_status     = lookup(each.value, "endpoint_status", null)
  geo_mappings        = split(",", replace(lookup(route.value, "geo_mappings", null), " ", ""))
  name                = each.key
  priority            = lookup(each.value, "priority", null)
  profile_name        = lookup(each.value, "profile_name", each.key)
  resource_group_name = lookup(each.value, "resource_group_name", azurerm_resource_group.traffic_manager_resource_group[0].name)
  dynamic "subnet" {
    for_each = lookup(var.traffic_manager_endpoint_subnets, each.key, null) != null ? lookup(var.traffic_manager_endpoint_subnets, each.key, null) : []
    content {
      first = subnet.value["first"]
      last  = subnet.value["last"]
      scope = subnet.value["scope"]
    }
  }
  target             = lookup(each.value, "target", null)
  target_resource_id = lookup(each.value, "target_resource_id", null)
  type               = lookup(each.value, "type", null)
  weight             = lookup(each.value, "weight", null)

  tags = var.common_tags
}
