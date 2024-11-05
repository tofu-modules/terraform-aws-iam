################################################################################
# Gitlab OIDC Role
################################################################################

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  # Just extra safety incase someone passes in a url with `https://`
  provider_url = replace(lower(var.provider_url), "https://", "")

  # Strip `project_path:` to normalize for cases where users may prepend it
  subjects = [for subject in var.subjects : "project_path:${trimprefix(subject, "project_path:")}"]

  match_field  = lower(var.match_field)
  match_values = length(var.match_values) == 0 && local.match_field == "aud" ? [local.provider_url] : var.match_values

  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
}

data "aws_iam_policy_document" "this" {
  count = var.create ? 1 : 0

  statement {
    sid    = "GitlabOIDCAuth"
    effect = "Allow"
    actions = [
      "sts:TagSession",
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:oidc-provider/${local.provider_url}"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "${local.provider_url}:iss"
      values   = ["https://${local.provider_url}"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "${local.provider_url}:${local.match_field}"
      values   = local.match_values
    }

    condition {
      test     = "StringLike"
      variable = "${local.provider_url}:sub"
      values   = local.subjects
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name        = var.name
  name_prefix = var.name_prefix
  path        = var.path
  description = var.description

  assume_role_policy    = data.aws_iam_policy_document.this[0].json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = var.force_detach_policies

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in var.policies : k => v if var.create }

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
