tf_aws_aurora
===========

Terraform module for deploying and managing AWS Aurora

This module

- we encrypt everything and make a kms id for you
- future enhancement to make kms_key_id optional, so if you do pass it it'll use it, and if you don't it'll create the kms key id for you

----------------------
#### Required


- `azs` - "A list of Availability Zones in the Region"
- `cluster_size` - "Number of cluster instances to create"
- `env` - "env to deploy into, should typically dev/staging/prod"
- `name` - "Name for the Redis replication group i.e. cmsCommon"
- `subnets` - "List of subnet IDs to use in creating RDS subnet group (must already exist)"
- `vpc_id`  - "VPC ID"

##### see [aws_rds_cluster documentation](https://www.terraform.io/docs/providers/aws/r/rds_cluster.html) for these variables
- `database_name`
- `master_username`
- `master_password`

#### Optional
- `backup_retention_period` - "The days to retain backups for defaults to 30"
- `db_port` - "defaults to 3306"
- `allowed_cidr` - "A list of CIDR addresses that can access the cluster. Defaults to ["127.0.0.1/32"]"
- `allowed_security_groups` - "A list of Security Group ID's to allow access to. Defaults to empty list"
- `preferred_backup_window` - "The daily time range in UTC during which automated backups are created. Default to 01:00-03:00"
- `instance_class` - "Instance class to use when creating RDS cluster. Defaults to db.t2.medium"
- `storage_encrypted` - "Defaults to true"
- `apply_immediately` - "Defaults to false"
- `iam_database_authentication_enabled` - "Whether to enable IAM database authentication. Detaults to false"
- `engine` - "Name of the db Engine for Aurora mysql 5.7 use aurora-mysql. Defaults to Aurora mysql 5.6"
- `major_engine_version` - "Name of the major engine. Defaults to 5.6"
- `family` - "Name of the family db parameter group for 5.7 use aurora-mysql5.7. Defaults to Aurora aurora5.6"

Usage
-----

```hcl

module "aurora" {
  source = "github.com/terraform-community-modules/tf_aws_aurora?ref=1.0.0"
  azs                     = var.azs
  env                     = var.env
  name                    = "thtest"
  subnets                 = module.vpc.database_subnets
  vpc_id                  = module.vpc.vpc_id
  cluster_size            = "2"
  allowed_cidr            = ["10.10.10.0/24", "10.10.20.0/24"]
  allowed_security_groups = ["sg-24f4655b"]
  database_name           = "thtest"
  master_username         = "tim"
  master_password         = "test1234"
  backup_retention_period = "1"
  #preferred_backup_window = ""
  
  cluster_parameters = [
    {
      name  = "binlog_checksum"
      value = "NONE"
    },
    {
      name         = "binlog_format"
      value        = "statement"
      apply_method = "pending-reboot"
    }
  ]
  
  db_parameters = [
    {
      name  = "long_query_time"
      value = "2"
    },
    {
      name  = "slow_query_log"
      value = "1"
    }
  ]

}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| database\_name | Name for an automatically created database on cluster creation. | string | n/a | yes |
| env | env to deploy into, should typically dev/staging/prod | string | n/a | yes |
| master\_password | (Required unless a snapshot\_identifier is provided) Password for the master DB user. | string | n/a | yes |
| master\_username | (Required unless a snapshot\_identifier is provided) Username for the master DB user. | string | n/a | yes |
| subnets | Subnets to use in creating RDS subnet group (must already exist) | list(string) | n/a | yes |
| vpc\_id | VPC ID | string | n/a | yes |
| allowed\_cidr | A list of IP ranges to allow access to. | list(string) | `[ "10.0.0.0/16" ]` | no |
| allowed\_security\_groups | A list of Security Group ID's to allow access to. | list(string) | `[]` | no |
| apply\_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is false | string | `"false"` | no |
| backup\_retention\_period | The days to retain backups for | string | `"35"` | no |
| cluster\_parameters | A list of cluster parameter maps to apply | list(map(string)) | `[]` | no |
| cluster\_size | Number of cluster instances to create | string | `"2"` | no |
| db\_parameters | A list of db parameter maps to apply | list(map(string)) | `[]` | no |
| db\_port | database port, default is 3306 | string | `"3306"` | no |
| engine | The name of the database engine to be used for this DB cluster. Defaults to aurora. Valid Values: aurora, aurora-mysql, aurora-postgresql, should be updated with major\_engine\_version and family together | string | `"aurora"` | no |
| family | The family of the DB parameter group, should be updated with major\_engine\_version and engine together | string | `"aurora5.6"` | no |
| iam\_database\_authentication\_enabled | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled. | string | `"false"` | no |
| instance\_class | Instance class to use when creating RDS cluster | string | `"db.t2.medium"` | no |
| major\_engine\_version | The database engine version, should be updated with engine and family together | string | `"5.6"` | no |
| preferred\_backup\_window | The daily time range during which automated backups are created | string | `"01:00-03:00"` | no |
| prevent\_destroy | This flag provides extra protection against the destruction of a given resource. When this is set to true, any plan that includes a destroy of this resource will return an error message. | string | `"true"` | no |
| publicly\_accessible | Should the instance get a public IP address? | string | `"false"` | no |
| region | aws region | string | `"ap-southeast-2"` | no |
| skip\_final\_snapshot | Determines whether a final DB snapshot is created before the DB cluster is deleted. Default is false. | string | `"false"` | no |
| stack | project name or stack name to identify the resources | string | `"o2a-aurora"` | no |
| storage\_encrypted | Specifies whether the DB cluster is encrypted | string | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| rds\_cluster\_id |  |
| reader\_endpoint |  |
| security\_group\_id |  |
| writer\_endpoint |  |


## Notes

Because of [this issue](https://github.com/hashicorp/terraform/issues/3116), if you need destroy the database, recommend to manually delete it from console only.

Let terraform/terragrunt to take care the rest resources.

Authors
=======

[Tim Hartmann](https://github.com/tfhartmann)
[Bill Wang](https://github.com/ozbillwang)

License
=======
