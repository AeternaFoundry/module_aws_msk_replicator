variable "msk_replicators" {
  description = <<EOT
Map of msk_replicators, attributes below
Required:
    - replicator_name
    - service_execution_role_arn
    - kafka_cluster (block):
        - amazon_msk_cluster (required, block):
            - msk_cluster_arn (required)
        - vpc_config (required, block):
            - security_groups_ids (optional)
            - subnet_ids (required)
    - replication_info_list (block):
        - consumer_group_replication (required, block):
            - consumer_group_offset_sync_mode (optional)
            - consumer_groups_to_exclude (optional)
            - consumer_groups_to_replicate (required)
            - detect_and_copy_new_consumer_groups (optional)
            - synchronise_consumer_group_offsets (optional)
        - source_kafka_cluster_arn (required)
        - target_compression_type (required)
        - target_kafka_cluster_arn (required)
        - topic_replication (required, block):
            - copy_access_control_lists_for_topics (optional)
            - copy_topic_configurations (optional)
            - detect_and_copy_new_topics (optional)
            - starting_position (optional, block):
                - type (optional)
            - topic_name_configuration (optional, block):
                - type (optional)
            - topics_to_exclude (optional)
            - topics_to_replicate (required)
Optional:
    - description
    - region
    - tags
    - tags_all
    - log_delivery (block):
        - replicator_log_delivery (optional, block):
            - cloudwatch_logs (optional, block):
                - enabled (required)
                - log_group (optional)
            - firehose (optional, block):
                - delivery_stream (optional)
                - enabled (required)
            - s3 (optional, block):
                - bucket (optional)
                - enabled (required)
                - prefix (optional)
EOT

  type = map(object({
    replicator_name            = string
    service_execution_role_arn = string
    description                = optional(string)
    region                     = optional(string)
    tags                       = optional(map(string))
    tags_all                   = optional(map(string))
    kafka_cluster = list(object({
      amazon_msk_cluster = object({
        msk_cluster_arn = string
      })
      vpc_config = object({
        security_groups_ids = optional(set(string))
        subnet_ids          = set(string)
      })
    }))
    replication_info_list = object({
      consumer_group_replication = list(object({
        consumer_group_offset_sync_mode     = optional(string)
        consumer_groups_to_exclude          = optional(set(string))
        consumer_groups_to_replicate        = set(string)
        detect_and_copy_new_consumer_groups = optional(bool)
        synchronise_consumer_group_offsets  = optional(bool)
      }))
      source_kafka_cluster_arn = string
      target_compression_type  = string
      target_kafka_cluster_arn = string
      topic_replication = list(object({
        copy_access_control_lists_for_topics = optional(bool)
        copy_topic_configurations            = optional(bool)
        detect_and_copy_new_topics           = optional(bool)
        starting_position = optional(object({
          type = optional(string)
        }))
        topic_name_configuration = optional(object({
          type = optional(string)
        }))
        topics_to_exclude   = optional(set(string))
        topics_to_replicate = set(string)
      }))
    })
    log_delivery = optional(object({
      replicator_log_delivery = optional(object({
        cloudwatch_logs = optional(object({
          enabled   = bool
          log_group = optional(string)
        }))
        firehose = optional(object({
          delivery_stream = optional(string)
          enabled         = bool
        }))
        s3 = optional(object({
          bucket  = optional(string)
          enabled = bool
          prefix  = optional(string)
        }))
      }))
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.msk_replicators : (
        length(v.kafka_cluster) >= 2 && length(v.kafka_cluster) <= 2
      )
    ])
    error_message = "Each kafka_cluster list must contain between 2 and 2 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.msk_replicators : (
        length(v.replication_info_list.consumer_group_replication) >= 1
      )
    ])
    error_message = "Each consumer_group_replication list must contain at least 1 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.msk_replicators : (
        length(v.replication_info_list.topic_replication) >= 1
      )
    ])
    error_message = "Each topic_replication list must contain at least 1 items"
  }
  # Note: 7 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

