variable "create" {
  description = "Create any resources or not"
  type        = bool
  default     = true
}

variable "name" {
  description = "IAM role name"
  type        = string
}

variable "description" {
  description = "IAM role description"
  type        = string
  default     = ""
}

variable "assume_role_policy" {
  description = "IAM role assume role policy document"
  type        = string
  default     = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

variable "force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it. Defaults to false"
  type        = bool
  default     = false
}

variable "path" {
  description = "The path to the role. See IAM Identifiers for more information."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours."
  type        = number
  default     = 3600
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = ""
}

variable "inline_policies" {
  description = "List of maps of inline policies to attach to the IAM role.  [{ name = \"\", policy = \"policy_document\" }, ]"
  type        = list(map(string))
  default     = []
}

variable "policies" {
  description = "List of maps to create additional IAM policies and attach to the IAM role. [ {name = \"\", name_suffix = \"\", description = \"\", path = \"/\", policy_document = \"\" }, ]"
  type        = list(map(string))
  default     = []
}

variable "attached_policies" {
  description = "List of existed IAM policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Create IAM instance profile for the IAM role"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to add to the IAM role"
  type        = map(string)
  default     = {}
}
