// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source = "git::https://github.com/nexient-llc/tf-module-resource_name.git?ref=1.0.0"

  for_each = var.resource_names_map

  logical_product_family  = var.product_family
  logical_product_service = var.product_service
  region                  = var.region
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  maximum_length          = each.value.max_length
}

module "resource_group" {
  source = "git::https://github.com/nexient-llc/tf-azurerm-module_primitive-resource_group.git?ref=0.2.0"

  name     = module.resource_names["rg"].standard
  location = var.region

  tags = merge(var.tags, { resource_name = module.resource_names["rg"].standard })

}

module "vnet" {
  source = "git@github.com:nexient-llc/tf-azurerm-module_primitive-virtual_network.git?ref=feature/init"

  vnet_location                                         = var.region
  resource_group_name                                   = module.resource_group.name
  vnet_name                                             = module.resource_names["vnet"].standard
  address_space                                         = var.address_space
  subnet_names                                          = var.subnet_names
  subnet_prefixes                                       = var.subnet_prefixes
  bgp_community                                         = null
  ddos_protection_plan                                  = null
  dns_servers                                           = []
  nsg_ids                                               = {}
  route_tables_ids                                      = {}
  subnet_delegation                                     = {}
  subnet_enforce_private_link_endpoint_network_policies = {}
  subnet_enforce_private_link_service_network_policies  = {}
  subnet_service_endpoints                              = {}
  tracing_tags_enabled                                  = false
  tracing_tags_prefix                                   = ""
  use_for_each                                          = true

  tags = merge(var.tags, { resource_name = module.resource_names["vnet"].standard })

  depends_on = [module.resource_group]
}

module "acr" {
  source = "git@github.com:nexient-llc/tf-azurerm-module_primitive-container_registry.git?ref=feature/network-rules"

  container_registry_name       = module.resource_names["acr"].lower_case_without_any_separators
  location                      = var.region
  resource_group_name           = module.resource_group.name
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false

  tags = merge(var.tags, { resource_name = module.resource_names["acr"].standard })

  depends_on = [module.resource_group]

}

module "private_dns_zone" {
  source = "git@github.com:nexient-llc/tf-azurerm-module_primitive-private_dns_zone.git?ref=feature/init"

  zone_name           = "privatelink.azurecr.io"
  resource_group_name = module.resource_group.name

  tags = var.tags

  depends_on = [module.resource_group]
}

module "vnet_link" {
  source = "git@github.com:nexient-llc/tf-azurerm-module_primitive-private_dns_vnet_link.git?ref=feature/init"

  link_name             = "acr-pe-link"
  private_dns_zone_name = module.private_dns_zone.zone_name
  virtual_network_id    = module.vnet.vnet_id
  resource_group_name   = module.resource_group.name

  tags = var.tags

  depends_on = [module.private_dns_zone, module.resource_group, module.vnet]
}

module "private_endpoint" {
  source = "../.."

  endpoint_name                   = module.resource_names["private_endpoint"].standard
  is_manual_connection            = false
  resource_group_name             = module.resource_group.name
  private_service_connection_name = "pvt-conn-acr"
  private_connection_resource_id  = module.acr.container_registry_id
  subresource_names               = ["registry"]
  subnet_id                       = module.vnet.vnet_subnets[0]
  private_dns_zone_ids            = [module.private_dns_zone.id]
  private_dns_zone_group_name     = "default-test"

  tags = var.tags

  depends_on = [module.resource_group, module.vnet, module.acr, module.private_dns_zone]
}
