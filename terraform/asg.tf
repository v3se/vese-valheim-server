data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

data "template_file" "user_data" {
  template = file("user_data.config.tpl")
  vars = {
    ECS_CLUSTER = aws_ecs_cluster.ecs_cluster.name
    EBS_REGION  = var.aws_region
  }
}

data "aws_iam_policy_document" "ecs_rexrays_policy" {
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteVolume",
      "ec2:DeleteSnapshot",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeSnapshots",
      "ec2:CopySnapshot",
      "ec2:DescribeSnapshotAttribute",
      "ec2:DetachVolume",
      "ec2:ModifySnapshotAttribute",
      "ec2:ModifyVolumeAttribute",
      "ec2:DescribeTags"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecs_rexray_iam_policy" {
  name   = "rexray_iam_policy"
  policy = data.aws_iam_policy_document.ecs_rexrays_policy.json
}

resource "aws_iam_role_policy_attachment" "valheim-ecs" {
  role       = aws_iam_role.valheim.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "valheim-rexray" {
  role       = aws_iam_role.valheim.name
  policy_arn = aws_iam_policy.ecs_rexray_iam_policy.arn
}

resource "aws_iam_instance_profile" "valheim" {
  name = "valheim"
  role = aws_iam_role.valheim.name
}

resource "aws_iam_role" "valheim" {
  name = "valheim"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "valheim-lt"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.valheim.id]
  user_data              = base64encode(data.template_file.user_data.rendered)
  key_name               = aws_key_pair.valheim.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.valheim.name
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                = "valheim-asg"
  max_size            = 1
  min_size            = 1
  availability_zones  = ["eu-north-1a"]

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }
}