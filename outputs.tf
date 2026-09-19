output "github_actions_role_arn" {
  value = data.aws_iam_role.github_role.arn
}