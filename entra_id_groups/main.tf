locals {
  users = toset(flatten([for group in var.groups : concat(try(group.members, []), try(group.owners, []))]))

  user_ids = { for user in local.users : user => data.azuread_user.user[user].id }

  members = { for v in flatten([for group_name, group_value in try(var.groups, {}) :
    [for member in try(group_value.members, []) : {
      group_name : group_name
      member : member
      }
    ]
  ]) : "${v.group_name}-${v.member}" => v }

  group_ids = { for group in azuread_group.group : group.display_name => group.id }
}


data "azuread_client_config" "current" {}

resource "azuread_group" "group" {
  for_each = var.groups

  display_name     = each.key
  owners           = toset(concat([data.azuread_client_config.current.object_id], try([for owner in each.value.owners : local.user_ids[owner]], [])))
  security_enabled = true
}

data "azuread_user" "user" {
  for_each            = local.users
  user_principal_name = each.key
}

resource "azuread_group_member" "member" {
  for_each = local.members

  group_object_id  = azuread_group.group[each.value.group_name].id
  member_object_id = local.user_ids[each.value.member]
}
