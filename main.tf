locals {
    groups = yamldecode(file("${path.module}/groups.yaml")
    users = toset(flatten([for group in local.groups : concat(try(group.members, []), try(group.owners, []))]))
}

data "azuread_client_config" "current" {}

resource "azuread_group" "group" {
  for_each = local.groups

  display_name     = each.key
  owners           = concat([data.azuread_client_config.current.object_id], try(each.value.owners, []))
  security_enabled = true
}

data "azuread_user" "user" {
  for_each = local.users
  user_principal_name = each.key
}

resource "azuread_group_member" "member" {
  for_each = local.groups

  group_object_id  = azuread_group.user.id
  member_object_id = data.azuread_user.user.id
}
