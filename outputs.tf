// Aurora cluster id
output "rds_cluster_id" {
  value = aws_rds_cluster.aurora.id
}

// Aurora cluster's writer endpoint
output "writer_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

// Aurora cluster's reader endpoint
output "reader_endpoint" {
  value = aws_rds_cluster.aurora.reader_endpoint
}

// Aurora cluster's security group id
output "security_group_id" {
  value = aws_security_group.aurora_security_group.id
}

