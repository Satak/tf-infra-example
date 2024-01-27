locals {
  folders = {
    groups : "/groups"
  }

  config = { for param, folder in local.folders :
    (param) => merge(flatten([for file in fileset(path.module, "${folder}/**/*.yaml") : yamldecode(file(file))])...)
  }
}

module "entra_id_groups" {
  source = "./entra_id_groups"
  groups = local.config.groups
}

output "users" {
  value = module.entra_id_groups.users
}

output "user_ids" {
  value = module.entra_id_groups.user_ids
}

output "group_ids" {
  value = module.entra_id_groups.group_ids
}
