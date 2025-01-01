variable "name" {}

variable "virtual_wan_id" {}

variable "rg" {
  type = object({
    name     = string
    location = string
  })
}

variable "authentication_types" {
  type = set(string)
}

variable "vpn_protocols" {
  type = set(string)
}

variable "client_root_certificate" {
  type    = map(string)
  default = {}
}

variable "aad_authentication" {
  type = object({
    audience = string
    issuer   = string
    tenant   = string
  })
  default = null
}

variable "policy_groups" {
  type = map(object({
    policies = list(object({
      name  = string
      type  = string
      value = string
    }))
  }))
  default = {}
}
