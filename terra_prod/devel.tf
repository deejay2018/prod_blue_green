
provider "aws" {
  region = "eu-west-1"
  profile = "default"
}

# toolbox instance
resource "aws_instance" "toolbox" {

  ami                         = "ami-0bb3fad3c0286ebd5"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.prometheus_key_pair.key_name
  subnet_id                   = aws_subnet.public-subnet-monitor.id
  #availability_zone           = data.aws_availability_zones.zones.names[0]
  vpc_security_group_ids      = [ aws_security_group.Monitor.id ]

  associate_public_ip_address = true

	root_block_device {
		volume_type = "gp2"
		delete_on_termination = true
	}

  tags = {
    Name = "Monitoring"
    Environment = "ToolBox"
  }
}

resource "aws_instance" "proxy" {

  ami                         = "ami-0bb3fad3c0286ebd5"
  instance_type               = "t2.micro"
    key_name                       = aws_key_pair.prometheus_key_pair.key_name

  subnet_id                   = aws_subnet.public-subnet-webserver.id
  #availability_zone           = data.aws_availability_zones.zones.names[0]
  vpc_security_group_ids      = [ aws_security_group.web.id ]
  associate_public_ip_address = true
  user_data                   = file("proxy_req.sh")

	root_block_device {
		volume_type = "gp2"
		delete_on_termination = true
	}

  tags = {
    Name = "Proxy server"
  }
}

resource "aws_instance" "appserver-1" {

  ami                         = var.AMI_ID  #Packer AMI
  instance_type               = "t2.micro"
  key_name                     = aws_key_pair.prometheus_key_pair.key_name
  subnet_id                   = aws_subnet.private-subnet-1.id
  #availability_zone           = data.aws_availability_zones.zones.names[0]
  vpc_security_group_ids      = [ aws_security_group.app-blue.id ]
  associate_public_ip_address = true


	root_block_device {
		volume_type = "gp2"
		delete_on_termination = true
	}

  tags = {
    Name = "Blues"
  }
}

resource "aws_instance" "appserver-2" {


  ami                         = var.AMI_ID #packer AMI
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.prometheus_key_pair.key_name
  subnet_id                   = aws_subnet.private-subnet-2.id
  #availability_zone           = data.aws_availability_zones.zones.names[0]
  vpc_security_group_ids      = [ aws_security_group.app-green.id ]
  associate_public_ip_address = true

	root_block_device {
		volume_type = "gp2"
		delete_on_termination = true
	}

  tags = {
    Name = "Greens"
  }
}



#Remote and local execution
resource "null_resource" "toolbox-provisioner" {

    triggers = {
    public_ip = aws_instance.toolbox.public_ip
  }
    connection {
    user          = "ec2-user"
    host          = aws_instance.toolbox.public_ip
    private_key   = tls_private_key.sshkeygen_execution.private_key_pem
    timeout       = "30"
  }

    # Copy the prometheus file to instance
  provisioner "file" {
    source      = "../ansible_build"
    destination = "/tmp"
  }



# Install docker in the centos
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum remove -y java",
      "sudo yum install -y java-1.8.0-openjdk-devel-debug.x86_64",
      "sudo yum install -y git",
      "sudo amazon-linux-extras install docker -y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import  https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum install -y jenkins --nogpgcheck",
      "sudo usermod -a -G docker jenkins",
      "sudo service docker start",
      "sudo systemctl enable docker",
      "sudo systemctl start jenkins",
      "sudo yum install python-pip -y",
      "pip install docker-py  --user",
      "sudo amazon-linux-extras install ansible2 -y"




    ]
  }




  provisioner "local-exec" {
    command = "echo '${tls_private_key.sshkeygen_execution.private_key_pem}' >> ${aws_key_pair.prometheus_key_pair.id}.pem ; chmod 400 ${aws_key_pair.prometheus_key_pair.id}.pem"
  }


}













