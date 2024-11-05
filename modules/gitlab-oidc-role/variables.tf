variable "create" {
  description = "Controls if resources should be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to the resources created"
  type        = map(any)
  default     = {}
}

variable "name" {
  description = "Name of IAM role"
  type        = string
  default     = null
}

variable "path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = null
}

variable "description" {
  description = "IAM Role description"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "policies" {
  description = "Policies to attach to the IAM role in `{'static_name' = 'policy_arn'}` format"
  type        = map(string)
  default     = {}
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = null
}

variable "provider_url" {
  description = "The URL of the identity provider. Corresponds to the iss claim"
  type        = string
  default     = "gitlab.com"

  validation {
    condition     = !endswith(var.provider_url, "/")
    error_message = "The URL is not include a trailing slash."
  }
}

variable "subjects" {
  description = "List of Gitlab OIDC subjects (namesapce/project names) that are permitted by the trust policy. You do not need to prefix with `project_path:` as this is provided. Example: `['my-org/my-repo', 'my-org/my-repo1:*', 'my-orh/sub-org/my-repo2']`"
  type        = list(string)
  default     = []
}

variable "match_field" {
  description = "The field of ID Token payload, that the OIDC role filter on (see https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html). Defaults to `aud`."
  type        = string
  default     = "aud"
}

variable "match_values" {
  description = "List of values to match with the OIDC role filter field by `StringEquals` operator"
  type        = list(string)
  default     = []
}
