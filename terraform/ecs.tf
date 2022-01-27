locals {
  resource_prefix = aws_ecs_cluster.ecs_cluster.name
  volume_name     = "valheim-ebs"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "valheim-ecs-${var.aws_region}"
}

data "template_file" "valheim" {
  template = file("task_definition.json.tpl")
  vars = {
    container_name        = var.container_name
    image                 = var.ecs_image
    source_volume_data    = "valheim-data"
    source_volume_config  = "valheim-config"
    container_path_data   = "/opt/valheim"
    container_path_config = "/config"
    efs_id                = aws_efs_file_system.valheim.id
    SERVER_NAME           = var.server_name
    WORLD_NAME            = var.world_name
    SERVER_PASS           = var.server_pass
    ADMINLIST_IDS         = join(" ", var.adminlist_ids)
  }
}

resource "aws_ecs_task_definition" "valheim" {
  family                = "valheim"
  container_definitions = data.template_file.valheim.rendered
  task_role_arn         = aws_iam_role.valheim-efs.arn

  volume {
    name = "valheim-config"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.valheim.id
      root_directory     = "/apps/valheim/config"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.valheim.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "valheim-data"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.valheim.id
      root_directory     = "/apps/valheim/data"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.valheim.id
        iam             = "ENABLED"
      }
    }
  }

}

resource "aws_ecs_service" "ecs_svc" {
  name            = "${var.container_name}-svc"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.valheim.arn
  desired_count   = 1
}

resource "aws_efs_file_system" "valheim" {
  creation_token = "valheim"
  tags = {
    Name = "valheim"
  }
}

resource "aws_efs_access_point" "valheim" {
  file_system_id = aws_efs_file_system.valheim.id

  root_directory {
    path = "/apps/valheim"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = 700
    }
  }
}

data "aws_iam_policy_document" "efs-valheim" {
  statement {
    actions = [
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientMount",
    ]

    resources = [
      aws_efs_file_system.valheim.arn,
    ]
  }
}

resource "aws_iam_policy" "efs-valheim-policy" {
  name   = "efs-valheim-policy"
  policy = data.aws_iam_policy_document.efs-valheim.json
}

resource "aws_iam_role_policy_attachment" "efs-valheim" {
  role       = aws_iam_role.valheim-efs.name
  policy_arn = aws_iam_policy.efs-valheim-policy.arn
}

resource "aws_iam_role" "valheim-efs" {
  name = "valheim-efs"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ecs-tasks.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}


resource "aws_efs_mount_target" "valheim" {
  file_system_id = aws_efs_file_system.valheim.id
  subnet_id      = aws_subnet.valheim.id
}

resource "aws_subnet" "valheim" {
  vpc_id     = data.aws_vpc.valheim.id
  cidr_block = "172.31.128.0/24"

  tags = {
    Name = "valheim-efs-subnet"
  }
}


