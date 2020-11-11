locals {
  description = var.description == "" ? null : var.description
}

resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

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
  count = var.create ? length(var.inline_policies) : 0

  name   = lookup(var.inline_policies[count.index], "name", null)
  role   = aws_iam_role.this[0].id
  policy = var.inline_policies[count.index]["policy"]
}

resource "aws_iam_policy" "this" {
  count = var.create ? length(var.policies) : 0

  name = lookup(var.policies[count.index], "name", "") != "" ? lookup(var.policies[count.index], "name", "") : format(
    "%s%s%s",
    var.name,
    lookup(var.policies[count.index], "name_suffix", "") == "" ? "" : "-",
    lookup(var.policies[count.index], "name_suffix", "")
  )
  path        = lookup(var.policies[count.index], "path", "/")
  description = lookup(var.policies[count.index], "description", "")

  policy = var.policies[count.index]["policy_document"]
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.create ? length(var.policies) : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[count.index].arn
}

resource "aws_iam_role_policy_attachment" "external" {
  count = var.create ? length(var.attached_policies) : 0

  role       = aws_iam_role.this[0].name
  policy_arn = var.attached_policies[count.index]
}

resource "aws_iam_instance_profile" "this" {
  count = var.create && var.instance_profile_create ? 1 : 0
  name  = var.instance_profile_name != "" ? var.instance_profile_name : var.name
  role  = aws_iam_role.this[0].name
}
