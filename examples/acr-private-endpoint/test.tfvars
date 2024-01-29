address_space   = ["10.1.0.0/16"]
subnet_prefixes = ["10.1.10.0/24", "10.1.11.0/24"]


tags = {
  provisioner = "Terraform"
  purpose     = "Terratest Private Endpoint ACR"
}
