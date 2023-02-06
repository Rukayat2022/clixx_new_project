### Key Pair
#Use keygen to generate new keypairs
resource "aws_key_pair" "bastion-instance-kp" {
  key_name   = "test_instance_kp.pub"
  public_key = file(var.PATH_TO_BASTION_PUBLIC_KEY)
}

# Bastion server launch template in the public subnet
resource "aws_launch_template" "bastion_server_template" {
  name          = "bastion-az1-${local.name_acc_prefix}"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.bastion-instance-kp.id
  #user_data     = base64encode(file("${path.module}/webserver_btstrp.sh"))
  user_data     = base64encode(file("${path.module}/webserver_btstrp_new.sh"))

  network_interfaces {
    associate_public_ip_address = true
    device_index                = 0
    security_groups             = [aws_security_group.bastion-server-sg.id]
  }


  tags = {
    Name       = "bastion-server"
    OwnerEmail = "omoyeni982@gmail.com"
    StackTeam  = "Stackcloud9"
    Schedule   = "A"
    Backup     = "Yes"
  }

}




#Creating app servers

# Key Pair
#Use keygen to generate new keypairs
resource "aws_key_pair" "appserver-instance-kp" {
  key_name   = "private_ruk.pub"
  public_key = file(var.PATH_TO_APPSERVER_PUBLIC_KEY)
}

resource "aws_launch_template" "app_server_template" {
  name                   = "app_server"
  vpc_security_group_ids = [aws_security_group.server-lt-sg.id]
  image_id               = "${local.wp_creds.ami_id}"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.appserver-instance-kp.key_name
 
  user_data = "${base64encode(<<EOF
        ${templatefile("${path.module}/clixx_application_btstrp_new.sh",
    { my_webip    = aws_lb.app_server_elb.dns_name, db_username = "${local.wp_creds.dbuser_name}",
      db_password = "${local.wp_creds.pass_wort}", region = "${local.wp_creds.AWS_REGION}",
      db_name     = "${local.wp_creds.dbasename}",
      efs_dnsname = aws_efs_file_system.app-server-efs.dns_name, MOUNT_POINT = var.mount_point, wp_config_dir = "/var/www/html/CliXX_Retail_Repository",
  rds_db = element(split(":", aws_db_instance.database-instance.endpoint), 0) })}
        EOF
)}"


#new_host = aws_db_instance.database-instance.address, 

dynamic "block_device_mappings" {
  for_each = [for vol in var.dev_names : {
    device_name           = "/dev/${vol}"
    virtual_name          = "ebs_dsk-${vol}"
    delete_on_termination = true
    encrypted             = false
    volume_size           = 10
    volume_type           = "gp2"
  }]
  content {
    device_name  = block_device_mappings.value.device_name
    virtual_name = block_device_mappings.value.virtual_name

    ebs {
      delete_on_termination = block_device_mappings.value.delete_on_termination
      encrypted             = block_device_mappings.value.encrypted
      volume_size           = block_device_mappings.value.volume_size
      volume_type           = block_device_mappings.value.volume_type
    }
  }

}

}
