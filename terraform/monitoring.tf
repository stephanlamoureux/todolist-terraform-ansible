// Create SNS topic for database alarms
resource "aws_sns_topic" "todolist_database_alarms" {
  name = "todolist_database_alarms"
}

// Subscription for SNS topic - sends notifications to the specified email
resource "aws_sns_topic_subscription" "todolist_database_alarms_email" {
  topic_arn = aws_sns_topic.todolist_database_alarms.arn
  protocol  = "email"
  endpoint  = "sa.lamoureux@gmail.com"
}

// CPU utilization alarm for target node 2 (database)
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1" // Number of consecutive periods for which the metric condition must be true
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"      // in seconds
  statistic           = "Average" // metric aggregation type
  threshold           = "75"      // threshold for triggering the alarm (75% CPU utilization)
  alarm_description   = "This alarm monitors EC2 CPU utilization"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.todolist_database_alarms.arn] // Action to trigger SNS notification
  dimensions = {
    InstanceId = module.target-node-2.instance_id // Reference to the instance ID from module
  }
}

// Network in traffic alarm for target node 2 (database)
resource "aws_cloudwatch_metric_alarm" "high_network_in" {
  alarm_name          = "high-network-in"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = "60" // 1 minute
  statistic           = "Average"
  threshold           = "10000000" // 10MB threshold (in bytes)
  alarm_description   = "This alarm monitors EC2 incoming network traffic"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.todolist_database_alarms.arn] // Action to trigger SNS notification
  dimensions = {
    InstanceId = module.target-node-2.instance_id // Reference to the instance ID from module
  }
}

// Network out traffic alarm for target node 2 (database)
resource "aws_cloudwatch_metric_alarm" "high_network_out" {
  alarm_name          = "high-network-out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2" // Two evaluation periods
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = "60" // 1 minute
  statistic           = "Average"
  threshold           = "10000000" // 10MB threshold (in bytes)
  alarm_description   = "This alarm monitors EC2 outgoing network traffic"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.todolist_database_alarms.arn] // Action to trigger SNS notification
  dimensions = {
    InstanceId = module.target-node-2.instance_id // Reference to the instance ID from module
  }
}
