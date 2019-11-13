resource "aws_kms_key" "aurora" {
  description             = "RDS master key for ${local.name}"
  deletion_window_in_days = 30
  enable_key_rotation     = "true"

  tags = merge(
    local.common_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_kms_alias" "aurora" {
  name          = "alias/${local.name}"
  target_key_id = aws_kms_key.aurora.key_id
}

