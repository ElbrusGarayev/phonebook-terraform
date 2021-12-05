resource "aws_security_group" "alb-security-group" {
  name = "ALB Security Group"
  description = "Enable HTTP/HTTPS access on 80/443"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTP Access"
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Access"
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group"
  }

}

resource "aws_security_group" "ssh-security-group" {
  name = "SSH Access"
  description = "SSH access enabling on 22"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH Access"
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [var.ssh-location]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group"
  }
}

resource "aws_security_group" "webserver-security-group" {
  name = "Web Server Security Group"
  description = "Enable HTTP/HTTPS access on 80/443 via ALB and SHH on 22 via SHH SG"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTP Access"
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = [aws_security_group.alb-security-group.id]
  }

  ingress {
    description = "HTTPS Access"
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = [aws_security_group.alb-security-group.id]
  }

  ingress {
    description = "SSH Access"
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [aws_security_group.ssh-security-group.id]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server Security Group"
  }

}

resource "aws_security_group" "database-security-group" {
  name = "DB Security Group"
  description = "Enable Mysql access on 3306"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "DB Access"
    from_port = 3306
    protocol  = "tcp"
    to_port   = 3306
    cidr_blocks = [var.private-subnet-4-cidr]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [var.private-subnet-4-cidr]
  }

  tags = {
    Name = "DB Security Group"
  }
}
