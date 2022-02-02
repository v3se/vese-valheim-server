resource "aws_instance" "valheim-server" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  associate_public_ip_address = true
  tags = {
    Name = "valheim-server"
  }
  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }
  vpc_security_group_ids  = [aws_security_group.valheim.id]
}

resource "aws_instance" "valheim-server" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  associate_public_ip_address = true
  tags = {
    Name = "valheim-server2"
  }
  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }
  vpc_security_group_ids  = [aws_security_group.valheim.id]
}

resource "aws_security_group" "valheim" {
  name        = "allow_valheim"
  description = "Allow Valheim server traffic"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "valheim_ingress_tcp" {
  type              = "ingress"
  from_port         = 2456
  to_port           = 2457
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.valheim.id
}

resource "aws_security_group_rule" "valheim_ingress_udp" {
  type              = "ingress"
  from_port         = 2456
  to_port           = 2457
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.valheim.id
}

resource "aws_security_group_rule" "valheim_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.ec2_management_source_ip]
  security_group_id = aws_security_group.valheim.id
}

resource "aws_security_group_rule" "valheim_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.valheim.id
}


