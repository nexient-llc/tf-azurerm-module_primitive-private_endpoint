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

variable "endpoint_name" {
  description = "Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = <<EOT
    Specifies the Name of the Resource Group within which the Private Endpoint should exist.
    Changing this forces a new resource to be created.
  EOT
  type        = string
}

variable "region" {
  description = "The supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = "eastus"
}

variable "subnet_id" {
  description = <<EOT
    The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint.
    Changing this forces a new resource to be created.
  EOT
  type        = string
}

variable "custom_network_interface_name" {
  description = <<EOT
    The custom name of the network interface attached to the private endpoint.
    Changing this forces a new resource to be created.
  EOT
  type        = string
  default     = null
}

variable "private_dns_zone_group_name" {
  description = "Specifies the Name of the Private DNS Zone Group."
  type        = string
  default     = ""
}

variable "private_dns_zone_ids" {
  description = "Specifies the list of Private DNS Zones to include"
  type        = list(string)
  default     = []
}

variable "private_service_connection_name" {}

variable "is_manual_connection" {}

variable "private_connection_resource_id" {
  description = <<EOT
    The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to.
    One of private_connection_resource_id or private_connection_resource_alias must be specified.
  EOT
  type        = string
  default     = null
}

variable "private_connection_resource_alias" {
  description = <<EOT
    The Service Alias of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to.
    One of private_connection_resource_id or private_connection_resource_alias must be specified.
  EOT
  type        = string
  default     = null
}

variable "subresource_names" {
  description = <<EOT
    A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id.
    Possible values are detailed in the product documentation in the Subresources column.
    https://docs.microsoft.com/azure/private-link/private-endpoint-overview#private-link-resource
  EOT
  type        = list(string)
  default     = null
}

variable "request_message" {
  description = <<EOT
    A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection
    to the remote resource. The request message can be a maximum of 140 characters in length.
    Only valid if `is_manual_connection=true`
  EOT
  type        = string
  default     = ""
}

variable "ip_configuration" {
  description = <<EOT
    One or more ip_configuration blocks as defined below. This allows a static IP address to be set for this
    Private Endpoint, otherwise an address is dynamically allocated from the Subnet.
  EOT
  type = map(object({
    name               = string
    private_ip_address = string
    subresource_name   = optional(string)
    member_name        = optional(string)
  }))

  default = null
}

variable "tags" {
  description = "A map of tags to be attached to this resource"
  type        = map(string)
  default     = {}
}
