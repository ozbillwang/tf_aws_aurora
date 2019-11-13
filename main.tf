provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier              = lower(replace(local.name, "_", "-"))
  availability_zones              = data.aws_availability_zones.available.names
  database_name                   = lower(replace(var.database_name, "/_|-/", ""))
  master_username                 = var.master_username
  master_password                 = var.master_password
  engine                          = var.engine
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  vpc_security_group_ids          = [aws_security_group.aurora_security_group.id]
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = aws_kms_key.aurora.arn
  apply_immediately               = var.apply_immediately
  db_subnet_group_name            = aws_db_subnet_group.aurora_subnet_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group.id

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "final-snapshot-${local.name}"

  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # https://github.com/hashicorp/terraform/issues/3116
  # So if you need destroy the database, recommend to manually delete it from console only.
  # Let terraform/terragrunt to take care the rest resources.
  lifecycle {
    prevent_destroy = "true" # https://www.terraform.io/docs/configuration/resources.html#prevent_destroy
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count                   = var.cluster_size
  identifier              = "${local.name}-${count.index}"
  engine                  = var.engine
  cluster_identifier      = aws_rds_cluster.aurora.id
  instance_class          = var.instance_class
  publicly_accessible     = var.publicly_accessible
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.id
  db_parameter_group_name = aws_db_parameter_group.aurora_parameter_group.id
  apply_immediately       = var.apply_immediately
  monitoring_role_arn     = aws_iam_role.aurora_instance_role.arn
  monitoring_interval     = "5"

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name}-${count.index}"
    },
  )
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = local.name
  subnet_ids = var.subnets

  tags = merge(
    local.common_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_db_parameter_group" "aurora_parameter_group" {
  name        = local.name
  family      = var.family
  description = "Terraform-managed parameter group for ${local.name}"

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group" {
  name        = local.name
  family      = var.family
  description = "Terraform-managed cluster parameter group for ${local.name}"

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_db_option_group" "aurora_option_group" {
  count                    = var.engine == "aurora-postgresql" ? 0 : 1
  name                     = local.name
  option_group_description = "Terraform-managed option group for ${local.name}"
  engine_name              = var.engine
  major_engine_version     = var.major_engine_version

  tags = merge(
    local.common_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_iam_role" "aurora_instance_role" {
  name               = local.name
  assume_role_policy = file("${path.module}/files/iam/assume_role_rds_monitoring.json")
}

resource "aws_iam_role_policy_attachment" "aurora_policy_rds_monitoring" {
  role       = aws_iam_role.aurora_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

