resource "aws_security_group" "this" {
  name_prefix = var.name
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "this_egress" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
}

resource "aws_security_group_rule" "this_ingress" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  cidr_blocks       = var.private_subnets_cidr_blocks
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
}

resource "aws_launch_template" "this" {
  name_prefix = var.name
  image_id    = var.image_id
  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.this.id]
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix         = var.name
  desired_capacity    = 1
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = var.public_subnets

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = 0
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version            = "$Latest"
      }
      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "this" {
  name_prefix = var.name
  role        = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name_prefix        = var.name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this.name
}
