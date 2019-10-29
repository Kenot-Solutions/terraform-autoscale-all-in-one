resource "aws_launch_configuration" "launchconfig" {
  name_prefix          = "launchconfig"
  image_id             = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type        = "t2.micro"
  key_name             = "${aws_key_pair.mykeypair.key_name}"
  security_groups      = ["${aws_security_group.myinstance.id}"]
  user_data            = "#!/bin/bash\napt-get update\napt-get -y install nginx\nsystemctl enable nginx\nsystemctl start nginx\nMYIP=`ifconfig | grep 'addr:10' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'this is: '$MYIP > /var/www/html/index.html"
  lifecycle              { create_before_destroy = true }
  enable_monitoring = true
}

resource "aws_autoscaling_group" "autoscaling" {
   name                = "autoscaling"
  vpc_zone_identifier  = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}","${aws_subnet.main-public-3.id}"]
  launch_configuration = "${aws_launch_configuration.launchconfig.name}"
  target_group_arns    = ["${aws_lb_target_group.asg.arn}"]
  health_check_type    = "ELB"
  min_size             = 2
  desired_capacity     = 2
  max_size             = 10

  tag {
    key = "Name"
    value = "terraform-asg-autoscaling"
    propagate_at_launch = true
  }
}

output "alb_dns_name" {
  value = "${aws_lb.my-elb.dns_name}"
  description = "The domain name of the load balancer"
}
