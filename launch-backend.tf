resource "tls_private_key" "template_backend_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "backend-instance-ec2-key" {
  key_name   = "key_backend"
  public_key = tls_private_key.template_backend_key.public_key_openssh
}

//Launch backend instance from sh file
resource "aws_launch_template" "launch-backend" {
  name = "backend"

  instance_type = "t2.micro"

  image_id = "ami-04902260ca3d33422"

  instance_initiated_shutdown_behavior = "terminate"

  update_default_version = true

  key_name = aws_key_pair.backend-instance-ec2-key.key_name

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.public-subnet-1
    security_groups             = [
      aws_security_group.webserver-security-group,
      aws_security_group.ssh-security-group
    ]
  }

  placement {
    availability_zone = "eu-central-1a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "phonebook-backend"
    }
  }

  user_data  = templatefile("sh/backend.sh", {
    mysql_url      = "jdbc:mysql://${aws_db_instance.database-instance.address}:${aws_db_instance.database-instance.port}/${aws_db_instance.database-instance.name}",
    mysql_username = aws_db_instance.database-instance.username, mysql_password = aws_db_instance.database-instance.password
  })
  depends_on = [aws_db_instance.database-instance]
}
