// Create SNS topic and subscription
resource "aws_sns_topic" "cloudwatch_alarms" {
  name = "cloudwatch-alarms"
}

resource "aws_sns_topic_subscription" "cloudwatch_alarms_email" {
  topic_arn = aws_sns_topic.cloudwatch_alarms.arn
  protocol  = "email"
  endpoint  = "sa.lamoureux@gmail.com"
}

// CPU utilization alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1" //  the number of consecutive periods for which the metric condition must be true before the alarm state changes.
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"      // in seconds
  statistic           = "Average" // metric aggregation type
  threshold           = "75"
  alarm_description   = "This alarm monitors EC2 CPU utilization"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
  dimensions = {
    InstanceId = module.target-node-2.instance_id
  }
}

// Network in traffic alarm
resource "aws_cloudwatch_metric_alarm" "high_network_in" {
  alarm_name          = "high-network-in"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "10000000" // about 10MB (threshold is in bytes)
  alarm_description   = "This alarm monitors EC2 incoming network traffic"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
  dimensions = {
    InstanceId = module.target-node-2.instance_id
  }
}

// Network out traffic alarm
resource "aws_cloudwatch_metric_alarm" "high_network_out" {
  alarm_name          = "high-network-out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "10000000" // Set your threshold (in bytes)
  alarm_description   = "This alarm monitors EC2 outgoing network traffic"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
  dimensions = {
    InstanceId = module.target-node-2.instance_id
  }
}
