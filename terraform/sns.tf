resource "aws_sns_topic" "valheim" {
  name = "valheim-status"
}

resource "aws_sns_topic_subscription" "valheim" {
  topic_arn = aws_sns_topic.valheim.arn
  protocol  = "email"
  endpoint  = var.sns_email # ToDo: Lambda function
}