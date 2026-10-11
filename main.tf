resource "aws_msk_replicator" "msk_replicators" {
  for_each = var.msk_replicators

  replicator_name            = each.value.replicator_name
  service_execution_role_arn = each.value.service_execution_role_arn
  description                = each.value.description
  region                     = each.value.region
  tags                       = each.value.tags
  tags_all                   = each.value.tags_all

  dynamic "kafka_cluster" {
    for_each = each.value.kafka_cluster
    content {
      amazon_msk_cluster {
        msk_cluster_arn = kafka_cluster.value.amazon_msk_cluster.msk_cluster_arn
      }
      vpc_config {
        security_groups_ids = kafka_cluster.value.vpc_config.security_groups_ids
        subnet_ids          = kafka_cluster.value.vpc_config.subnet_ids
      }
    }
  }

  replication_info_list {
    dynamic "consumer_group_replication" {
      for_each = each.value.replication_info_list.consumer_group_replication
      content {
        consumer_group_offset_sync_mode     = consumer_group_replication.value.consumer_group_offset_sync_mode
        consumer_groups_to_exclude          = consumer_group_replication.value.consumer_groups_to_exclude
        consumer_groups_to_replicate        = consumer_group_replication.value.consumer_groups_to_replicate
        detect_and_copy_new_consumer_groups = consumer_group_replication.value.detect_and_copy_new_consumer_groups
        synchronise_consumer_group_offsets  = consumer_group_replication.value.synchronise_consumer_group_offsets
      }
    }
    source_kafka_cluster_arn = each.value.replication_info_list.source_kafka_cluster_arn
    target_compression_type  = each.value.replication_info_list.target_compression_type
    target_kafka_cluster_arn = each.value.replication_info_list.target_kafka_cluster_arn
    dynamic "topic_replication" {
      for_each = each.value.replication_info_list.topic_replication
      content {
        copy_access_control_lists_for_topics = topic_replication.value.copy_access_control_lists_for_topics
        copy_topic_configurations            = topic_replication.value.copy_topic_configurations
        detect_and_copy_new_topics           = topic_replication.value.detect_and_copy_new_topics
        dynamic "starting_position" {
          for_each = topic_replication.value.starting_position != null ? [topic_replication.value.starting_position] : []
          content {
            type = starting_position.value.type
          }
        }
        dynamic "topic_name_configuration" {
          for_each = topic_replication.value.topic_name_configuration != null ? [topic_replication.value.topic_name_configuration] : []
          content {
            type = topic_name_configuration.value.type
          }
        }
        topics_to_exclude   = topic_replication.value.topics_to_exclude
        topics_to_replicate = topic_replication.value.topics_to_replicate
      }
    }
  }

  dynamic "log_delivery" {
    for_each = each.value.log_delivery != null ? [each.value.log_delivery] : []
    content {
      dynamic "replicator_log_delivery" {
        for_each = log_delivery.value.replicator_log_delivery != null ? [log_delivery.value.replicator_log_delivery] : []
        content {
          dynamic "cloudwatch_logs" {
            for_each = replicator_log_delivery.value.cloudwatch_logs != null ? [replicator_log_delivery.value.cloudwatch_logs] : []
            content {
              enabled   = cloudwatch_logs.value.enabled
              log_group = cloudwatch_logs.value.log_group
            }
          }
          dynamic "firehose" {
            for_each = replicator_log_delivery.value.firehose != null ? [replicator_log_delivery.value.firehose] : []
            content {
              delivery_stream = firehose.value.delivery_stream
              enabled         = firehose.value.enabled
            }
          }
          dynamic "s3" {
            for_each = replicator_log_delivery.value.s3 != null ? [replicator_log_delivery.value.s3] : []
            content {
              bucket  = s3.value.bucket
              enabled = s3.value.enabled
              prefix  = s3.value.prefix
            }
          }
        }
      }
    }
  }
}

