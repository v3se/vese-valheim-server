[
    {
        "name": "${container_name}",
        "image": "${image}",
        "cpu": 2,
        "memory": 3500,
        "essential": true,
        "mountPoints": [
            {
                "sourceVolume": "${source_volume}",
                "containerPath": "${container_path}"
            }    
        ],
        "command": [
            "sh",
            "-c",
            "ln -s /config /mnt/valheim-ebs && ln -s /opt/valheim /mnt/valheim-ebs && /usr/local/sbin/bootstrap"
        ],
        "environment": [
            {
                "name": "SERVER_NAME",
                "value": "${SERVER_NAME}"
            },
            {
                "name": "WORLD_NAME",
                "value": "${WORLD_NAME}"
            },
            {
                "name": "SERVER_PASS",
                "value": "${SERVER_PASS}"
            },
            {
                "name": "ADMINLIST_IDS",
                "value": "${ADMINLIST_IDS}"
            }
        ],
        "portMappings": [
            {
                "containerPort": 2456,
                "hostPort": 2456,
                "protocol": "udp"
            },
            {
                "containerPort": 2457,
                "hostPort": 2457,
                "protocol": "udp"
            },
            {
                "containerPort": 9001,
                "hostPort": 9001,
                "protocol": "tcp"
            }
        ]
    }
]


