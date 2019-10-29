/*
resource "aws_elb" "my-elb" {
  name = "my-elb"
  subnets = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}","${aws_subnet.main-public-3.id}"]
  security_groups = ["${aws_security_group.elb-securitygroup.id}"]
 listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 400
  tags = {
    Name = "my-elb"
  }
}
*/

resource "aws_lb" "my-elb" {
  name = "terraform-asg-my-elb"
  load_balancer_type = "application"
  subnets = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}","${aws_subnet.main-public-3.id}"]
  security_groups = ["${aws_security_group.elb-securitygroup.id}"]
}


resource "aws_lb_target_group" "asg" {
  name = "terraform-asg-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.my-elb.arn}"
  port = 80
  protocol = "HTTP"
  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 403
    }
  }
}

resource "aws_lb_listener_rule" "listener-rule" {
  listener_arn = "${aws_lb_listener.http.arn}"
  priority = 100

  condition {
    field = "path-pattern"
    values = ["*"]
    }
  action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.asg.arn}"
  }
}

