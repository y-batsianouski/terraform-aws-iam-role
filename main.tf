locals {
  description = var.description == "" ? null : var.description
}

resource "aws_iam_role" "this" {
  name        = var.name
  description = local.description
  path        = var.path

  assume_role_policy = var.assume_role_policy

  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary == "" ? null : var.permissions_boundary

  tags = var.tags
}

resource "aws_iam_role_policy" "inline" {
  count = length(var.inline_policies)

  name   = lookup(var.inline_policies[count.index], "name", null)
  role   = aws_iam_role.this.id
  policy = var.inline_policies[count.index]["policy"]
}

resource "aws_iam_policy" "this" {
  count = length(var.policies)

  name = format(
    "%s%s%s",
    var.name,
    lookup(var.policies[count.index], "name_suffix", "") == "" ? "" : "-",
    lookup(var.policies[count.index], "name_suffix", "")
  )
  path        = lookup(var.policies[count.index], "path", "/")
  description = lookup(var.policies[count.index], "description", "")

  policy = var.policies[count.index]["policy"]
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.policies)

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[count.index].arn
}

resource "aws_iam_role_policy_attachment" "external" {
  count = length(var.policies_attachements)

  role       = aws_iam_role.this.name
  policy_arn = var.policies_attachements[count.index]
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.name
  role  = aws_iam_role.this.name
}
