output "aws_ssoadmin_instances" {
  value = data.aws_ssoadmin_instances.this
}

output "groups" {
  value = var.groups
}

output "accounts" {
  value = data.aws_organizations_organizational_unit_descendant_accounts.this
}
