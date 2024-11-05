# IAM Gitlab OIDC role submodule

This submodule help create an IAM role for Gitlab   
See https://aws.amazon.com/blogs/apn/setting-up-openid-connect-with-gitlab-ci-cd-to-provide-secure-access-to-environments-in-aws-accounts/

## Usage

```hcl
module "deployer_role" {
  source  = "tofu-modules/iam/aws//modules/gitlab-oidc-role"
  version = "~>0.1.0"

  name_prefix  = "gitlab-ci-deployer-"
  path         = "/service-roles/"
  provider_url = "gitlab.example.com"
  subjects     = ["my-org/my-repo"]

  tags = {
    Namespace = "my-org"
    Project = "my-repo"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects all resources) | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | IAM Role description | `string` | `null` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether policies should be detached from this role when destroying | `bool` | `true` | no |
| <a name="input_match_field"></a> [match\_field](#input\_match\_field) | The field of ID Token payload, that the OIDC role filter on (see https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html). Defaults to `aud`. | `string` | `"aud"` | no |
| <a name="input_match_values"></a> [match\_values](#input\_match\_values) | List of values to match with the OIDC role filter field by `StringEquals` operator | `list(string)` | `[]` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200 | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of IAM role | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | IAM role name prefix | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | Path of IAM role | `string` | `"/"` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | Permissions boundary ARN to use for IAM role | `string` | `null` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Policies to attach to the IAM role in `{'static_name' = 'policy_arn'}` format | `map(string)` | `{}` | no |
| <a name="input_provider_url"></a> [provider\_url](#input\_provider\_url) | The URL of the identity provider. Corresponds to the iss claim | `string` | `"gitlab.com"` | no |
| <a name="input_subjects"></a> [subjects](#input\_subjects) | List of Gitlab OIDC subjects (namesapce/project names) that are permitted by the trust policy. You do not need to prefix with `project_path:` as this is provided. Example: `['my-org/my-repo', 'my-org/my-repo1:*', 'my-orh/sub-org/my-repo2']` | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources created | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of IAM role |
| <a name="output_name"></a> [name](#output\_name) | Name of IAM role |
| <a name="output_path"></a> [path](#output\_path) | Path of IAM role |
| <a name="output_unique_id"></a> [unique\_id](#output\_unique\_id) | Unique ID of IAM role |
<!-- END_TF_DOCS -->

## Contributing

All code contributions must go through a pull request and approved by a core developer before being merged.
This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues](https://github.com/tofu-modules/terraform-aws-iam/issues).

## License

This project is released under the MIT License.   
Copyright © 2024 [Oanh Nguyen](https://github.com/oanhnn)   
Please see [License File](https://github.com/tofu-modules/terraform-aws-iam/blob/main/LICENSE) for more information.
