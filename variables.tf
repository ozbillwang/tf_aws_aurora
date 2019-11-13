variable "region" {
  description = "aws region"
  default     = "ap-southeast-2"
}

variable "env" {
  description = "env to deploy into, should typically dev/staging/prod"
}

variable "stack" {
  description = "project name or stack name to identify the resources"
  default     = "o2a-aurora"
}

variable "allowed_cidr" {
  description = "A list of IP ranges to allow access to."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
  default     = []
}

variable "cluster_size" {
  description = "Number of cluster instances to create"
  default     = 2
}

variable "db_port" {
  description = "database port, default is 3306"
  default     = 3306
}

variable "instance_class" {
  description = "Instance class to use when creating RDS cluster"
  default     = "db.t2.medium"
}

variable "publicly_accessible" {
  description = "Should the instance get a public IP address?"
  default     = "false"
}

variable "subnets" {
  description = "Subnets to use in creating RDS subnet group (must already exist)"
  type        = list(string)
}

variable "cluster_parameters" {
  description = "A list of cluster parameter maps to apply"
  type        = list(map(string))
  default     = []
}

variable "db_parameters" {
  description = "A list of db parameter maps to apply"
  type        = list(map(string))
  default     = []
}

# see aws_rds_cluster documentation for these variables
variable "database_name" {
  description = "Name for an automatically created database on cluster creation."
}

# see [aws_rds_cluster documentation](https://www.terraform.io/docs/providers/aws/r/rds_cluster.html) for these variables
variable "master_username" {
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user."
}

variable "master_password" {
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user. "
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  default     = "35"
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  default     = "01:00-03:00"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is false"
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted. Default is false."
  default     = false
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  default     = false
}

variable "major_engine_version" {
  description = "The database engine version, should be updated with engine and family together"
  default     = "5.6"
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster. Defaults to aurora. Valid Values: aurora, aurora-mysql, aurora-postgresql, should be updated with major_engine_version and family together"
  default     = "aurora"
}

variable "family" {
  description = "The family of the DB parameter group, should be updated with major_engine_version and engine together"
  default     = "aurora5.6"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "prevent_destroy" {
  description = "This flag provides extra protection against the destruction of a given resource. When this is set to true, any plan that includes a destroy of this resource will return an error message."
  type        = string
  default     = "true"
}

