################################################################################
# Gitlab OIDC Provider
################################################################################

locals {
  url            = trimprefix(lower(var.url), "https://")
  client_id_list = coalescelist(var.client_id_list, [local.url])
}

data "tls_certificate" "this" {
  count = var.create ? 1 : 0

  # See https://github.com/hashicorp/terraform-provider-tls/issues/249
  # url should is format `tls://gitlab.com:443`
  url = "tls://${local.url}:443"
}

resource "aws_iam_openid_connect_provider" "this" {
  count = var.create ? 1 : 0

  url             = "https://${local.url}"
  client_id_list  = local.client_id_list
  thumbprint_list = distinct(concat(data.tls_certificate.this[0].certificates[*].sha1_fingerprint, var.additional_thumbprints))

  tags = var.tags
}
