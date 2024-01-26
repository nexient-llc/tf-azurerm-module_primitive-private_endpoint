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

output "private_endpoint_id" {
  value = module.private_endpoint.id
}

output "acr_server_name" {
  value = module.acr.container_registry_login_server
}

output "acr_id" {
  value = module.acr.container_registry_id
}

output "resource_group_id" {
  value = module.resource_group.id
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "subnet_ids" {
  value = module.vnet.vnet_subnets
}

output "vnet_link_id" {
  value = module.vnet_link.id
}
