resource "aws_identitystore_group" "this" {
  for_each = { for group in var.groups: group.name => group }
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = each.value.name
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each = { for group in var.groups: group.name => group }
  name         = each.value.name
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = [ for group in var.groups: { for manage_permission in group.manage_permissions: manage_permission => group.name } ][0]
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_policy_arn = each.key
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value].arn
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = [for group in var.groups: {for account in group.accounts: "${account}-${group.name}" => {"group"=group.name,"account"=account}}][0]
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.group].arn

  principal_id   = aws_identitystore_group.this[each.value.group].group_id 
  principal_type = "GROUP"

  target_id   = [for account in data.aws_organizations_organizational_unit_descendant_accounts.this.accounts: account.id if account.name == each.value.account][0]
  target_type = "AWS_ACCOUNT"   
}

resource "aws_identitystore_group_membership" "this" {
  for_each = [for group in var.groups: { for member in group.members: "${group.name}-${member}}" => {"group"=group.name, "member"= member } }][0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.this[each.value.group].group_id
  member_id         = aws_identitystore_user.this[each.value.member].user_id
}

data "aws_organizations_organizational_unit_descendant_accounts" "this" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}


