#!/bin/bash
echo ECS_CLUSTER=${ECS_CLUSTER} >> /etc/ecs/ecs.config

sudo stop ecs && sudo start ecs
