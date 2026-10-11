output "msk_replicators_id" {
  description = "Map of id values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.id if v.id != null && length(v.id) > 0 }
}
output "msk_replicators_arn" {
  description = "Map of arn values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.arn if v.arn != null && length(v.arn) > 0 }
}
output "msk_replicators_current_version" {
  description = "Map of current_version values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.current_version if v.current_version != null && length(v.current_version) > 0 }
}
output "msk_replicators_description" {
  description = "Map of description values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.description if v.description != null && length(v.description) > 0 }
}
output "msk_replicators_kafka_cluster" {
  description = "Map of kafka_cluster values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.kafka_cluster if v.kafka_cluster != null && length(v.kafka_cluster) > 0 }
}
output "msk_replicators_log_delivery" {
  description = "Map of log_delivery values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => one(v.log_delivery) if v.log_delivery != null && length(v.log_delivery) > 0 }
}
output "msk_replicators_region" {
  description = "Map of region values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.region if v.region != null && length(v.region) > 0 }
}
output "msk_replicators_replication_info_list" {
  description = "Map of replication_info_list values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => one(v.replication_info_list) if v.replication_info_list != null && length(v.replication_info_list) > 0 }
}
output "msk_replicators_replicator_name" {
  description = "Map of replicator_name values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.replicator_name if v.replicator_name != null && length(v.replicator_name) > 0 }
}
output "msk_replicators_service_execution_role_arn" {
  description = "Map of service_execution_role_arn values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.service_execution_role_arn if v.service_execution_role_arn != null && length(v.service_execution_role_arn) > 0 }
}
output "msk_replicators_tags" {
  description = "Map of tags values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.tags if v.tags != null && length(v.tags) > 0 }
}
output "msk_replicators_tags_all" {
  description = "Map of tags_all values across all msk_replicators, keyed the same as var.msk_replicators"
  value       = { for k, v in aws_msk_replicator.msk_replicators : k => v.tags_all if v.tags_all != null && length(v.tags_all) > 0 }
}

