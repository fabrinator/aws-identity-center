module "aws-identity-center" {
  source = "./module"
  users = [
    {
      name = "fabri"
      last_name = "frivas"
      username = "frivas"
    }
  ]
  groups = [
    {
      name = "Administrators"
      manage_permissions = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AdministratorAccess"]
      members = ["fabri"]
      accounts = ["AWS-ORG", "crc-prod", "crc-dev", "bootcamp-account", "infra-shared"]
    }
  ]
}


output "aws-identity-center" {
  value = module.aws-identity-center
}