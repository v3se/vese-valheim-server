### Common ###
project_common_tag = "valheim"
aws_region         = "eu-north-1"
public_key         = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrvvK9aM4JcBprOOHDRrxQ7OxbV0H52qLx4+8mH4tFnAi1NNtaKXLfoTW7E9Ajk2OJN9mcOTZRqbZYCEHd7Yc+zUmx2M5sm8t4GroXLjdYgy7IfmxWE/eH8Ih7rEd+UcjOYQfaK690bebNgrBDAukDDP0IFZFOnSYTr+yIpF2YKeDMChMC9FHAQyxqsUmO/TM6opqDipv6cqq7CS7HAEnzooDLg5BMRLbHknQAxjo5uFLjMBhZLKOYciVcLVgLm7JJsLamXuEAA+QA+Wvep3Sbb5d0DzV+13NeA7uIiUIzMNwSXQOkFsk/hvwX7PcPU/AuXf2APR7Ce7gZyxrRkcfH robban@DESKTOP-FUHKTQG"

### EC2 ###
ec2_instance_type = "t3.medium"
ec2_ami_id        = "ami-092cce4a19b438926"

### SNS ###
sns_email = "worsethanbullets@gmail.com"

### ECS ###
ecs_image      = "lloesche/valheim-server"
container_name = "valheim-server"

### Valheim ###
adminlist_ids = []
server_name   = "vese-valheim"
world_name    = "lul"
#server_pass = ""
