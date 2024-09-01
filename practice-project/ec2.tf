data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

resource "aws_launch_template" "dev" {
    image_id =  data.aws_ami.amzlinux.id
    instance_type = var.instance-type
    key_name = "cfn-key-1"
    vpc_security_group_ids = [aws_security_group.dev.id]
  
}

resource "aws_autoscaling_group" "dev" {
      launch_template {
       id      = aws_launch_template.dev.id
       version = "$Latest"
  }

  vpc_zone_identifier = [for s in aws_subnet.public : s.id]

  min_size = 1
  max_size = 3
  desired_capacity = 1

  tag {
    key                 = "Name"
    value               = "example-instance"
    propagate_at_launch = true
  }

  health_check_type          = "EC2"
  health_check_grace_period  = 300
  wait_for_capacity_timeout     = "0"
}



# Define an Auto Scaling Policy to scale up
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.dev.name
}


# Define an Auto Scaling Policy to scale down
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.dev.name
}

resource "aws_lb_target_group" "dev" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id

  # Health check configuration
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 3
    unhealthy_threshold  = 3
  }
}
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name                = "high-cpu-alarm"
  alarm_description         = "This alarm triggers when CPU utilization exceeds 50%."
  namespace                 = "AWS/EC2"
  metric_name               = "CPUUtilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.dev.name
  }
  statistic                = "Average"
  period                   = 60
  evaluation_periods       = 1
  threshold                = 50
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  alarm_actions            = [aws_autoscaling_policy.scale_up.arn]
}
resource "aws_lb" "dev" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "example-alb"
  }
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.dev.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello from ALB"
      status_code  = "200"
    }
  }
}
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.dev.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}
resource "aws_network_acl" "example" {
  vpc_id = aws_vpc.dev.id

  ingress {
    rule_no   = 22
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_block = "0.0.0.0/0"
    action = "allow"
  }

  egress {
    rule_no   = 22
    protocol  = "tcp"
    from_port = 0
    to_port   = 0
    cidr_block = "0.0.0.0/0"
    action   = "allow"
  }
}

  
  
  
