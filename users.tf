resource "aws_identitystore_user" "this" {
  for_each = { for user in var.users: user.name => user}
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0] 

  display_name = each.value.name
  user_name    = each.value.username

  name {
    given_name  = each.value.name
    family_name = each.value.last_name
  }

  emails {
    value = "${each.value.username}@fabririvas.com"
  }
}

