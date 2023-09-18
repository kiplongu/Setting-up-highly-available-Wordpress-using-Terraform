resource "aws_autoscaling_group" "web-server" {
  name     = "nginx-asg"
  max_size = 2
  min_size = 2
  #health_check_grace_period = 300
  #health_check_type         = "ELB"
  desired_capacity = 2
  force_delete     = true
  #placement_group           = aws_placement_group.test.id
  launch_configuration = aws_launch_configuration.web-server-launch-config.name
  vpc_zone_identifier  = ["subnet-0e3576770692f7860", "subnet-0b70f69048d89c0ad"]
  tag {
    key                 = "name"
    value               = "nginx-web-server-asg"
    propagate_at_launch = true
  }
}
resource "aws_launch_configuration" "web-server-launch-config" {
  name          = "web_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = data.template_file.asg_init.rendered

  lifecycle {
    create_before_destroy = true
    /* ignore_changes        = [load_balancers, target_group_arns] */
  }
}
data "template_file" "asg_init" {
  template = file("${path.module}/userdata.tpl")
  vars = {
    db_name = var.db_name
    db_pass = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["password"] #var.db_pass
    db_user = var.db_user
    db_host = aws_db_instance.wordpress.address
    #efs_id  = aws_efs_file_system.wordpress-efs.id
  }
}
