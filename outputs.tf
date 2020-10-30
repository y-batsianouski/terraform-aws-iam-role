output "iam_role" {
  description = "Created IAM role"
  value       = { for k, v in concat(aws_iam_role.this, [{}])[0] : k => v if contains(["tags"], k) == false }
}

output "inline_policies" {
  description = "Map of inline IAM policies"
  value       = aws_iam_role_policy.inline
}

output "policies" {
  description = "List of created IAM policies"
  value       = aws_iam_policy.this
}

output "instance_profile" {
  description = "IAM instance profile"
  value       = concat(aws_iam_instance_profile.this, [{}])[0]
}
