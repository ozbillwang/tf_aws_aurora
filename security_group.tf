resource "aws_security_group" "aurora_security_group" {
  name        = local.name
  description = "Terraform-managed RDS security group for ${local.name}"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_security_group_rule" "aurora_ingress" {
  count                    = length(var.allowed_security_groups)
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = aws_security_group.aurora_security_group.id
}

resource "aws_security_group_rule" "aurora_networks_ingress" {
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr
  security_group_id = aws_security_group.aurora_security_group.id
}

