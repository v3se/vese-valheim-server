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
    container_name = var.container_name
    image          = var.ecs_image
    source_volume  = local.volume_name
    container_path = "/mnt/valheim-ebs"
    SERVER_NAME = var.server_name
    WORLD_NAME = var.world_name
    SERVER_PASS = var.server_pass
    ADMINLIST_IDS = join(" ", var.adminlist_ids)
  }
}

resource "aws_ecs_task_definition" "valheim" {
  family = "valheim"
  container_definitions = data.template_file.valheim.rendered

  volume {
    name = local.volume_name
    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
      driver        = "rexray/ebs"
    }
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "eu-north-1a"
  size              = 5
  type              = "gp2"

  tags = {
    Name = local.volume_name
  }
}

resource "aws_ecs_service" "ecs_svc" {
  name            = "${var.container_name}-svc"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.valheim.arn
  desired_count   = 1
}

