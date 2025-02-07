resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Allow HTTP and SSH traffic"
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 

resource "aws_instance" "web_server" {
  ami           = "ami-085ad6ae776d8f09c"  
  instance_type = "t2.micro"
security_groups = [aws_security_group.web_sg.name]
 
 
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>This is My Apache Web Server</h1>" | sudo tee /var/www/html/index.html
  EOF
 
  tags = {
    Name = "Apache-WebServer"
  }
}
