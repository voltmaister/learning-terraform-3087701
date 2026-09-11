data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Official Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  
  # Update this to t3.micro
  instance_type = var.instance_type

  # This script installs Tomcat and Java automatically on first boot
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y default-jdk tomcat10
              systemctl enable tomcat10
              systemctl start tomcat10
              EOF

  tags = {
    Name = "HelloWorld"
  }
}
