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

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.endpoint_name
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                              = var.private_service_connection_name
    private_connection_resource_id    = var.private_connection_resource_id
    private_connection_resource_alias = var.private_connection_resource_alias
    subresource_names                 = var.subresource_names
    is_manual_connection              = var.is_manual_connection
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = var.private_dns_zone_group_name == "" ? "${var.endpoint_name}-dns-group" : var.private_dns_zone_group_name
      private_dns_zone_ids = var.private_dns_zone_ids
    }

  }

  tags = var.tags
}
