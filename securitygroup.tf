
# -- Creating Security Groups for public

resource "aws_security_group" "Monitor" {
	name        = "monitor-sg"
  	description = "Allow TLS inbound traffic"
  	vpc_id      = aws_vpc.MainVPC.id


  	ingress {
    		description = "SSH"
    		from_port   = 22
    		to_port     = 22
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}

	ingress {
    		description = "web"
    		from_port   = 80
    		to_port     = 80
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}


  	ingress {
    		description = "public-port1"
    		from_port   = 3000
    		to_port     = 3000
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

	ingress {
    		description = "public-port2"
    		from_port   = 9090
    		to_port     = 9090
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}


	ingress {
			description = "public-port3"
			from_port   = 9093
			to_port     = 9093
			protocol    = "tcp"
			cidr_blocks = [ "0.0.0.0/0" ]
}

	ingress {
    		description = "SSH"
    		from_port   = 9100
    		to_port     = 9100
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}

	ingress {
			description = "public-port4"
			from_port   = 9115
			to_port     = 9115
			protocol    = "tcp"
			cidr_blocks = [ "0.0.0.0/0" ]
}


	ingress {
			description = "public-port5"
			from_port   = 9300
			to_port     = 9300
			protocol    = "tcp"
			cidr_blocks = [ "0.0.0.0/0" ]
}

	ingress {
			description = "ping-ICMP-port5"
			from_port   = -1
			to_port     = -1
			protocol    = "icmp"
			cidr_blocks = [ "0.0.0.0/0" ]
			ipv6_cidr_blocks = ["::/0"]
}


  	egress {
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
  	}

  	tags = {
    		Name = "Monitoring"
  	}
}
resource "aws_security_group" "web" {
	name        = "webserver-sg"
  	description = "Allow TLS inbound traffic"
  	vpc_id      = aws_vpc.MainVPC.id


  	ingress {
    		description = "SSH"
    		from_port   = 22
    		to_port     = 22
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}


  	ingress {
    		description = "public-port"
    		from_port   = 80
    		to_port     = 80
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}



  	egress {
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
  	}

  	tags = {
    		Name = "Proxy"
  	}
}
# -- Creating Security Groups for private

resource "aws_security_group" "app-blue" {
	name        = "blue-sg"
  	description = "Disallow TLS inbound traffic"
  	vpc_id      = aws_vpc.MainVPC.id


	ingress {
    		description = "public-port"
    		from_port   = 80
    		to_port     = 80
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}

  	ingress {
    		description = "private-port"
    		from_port   = 6379
    		to_port     = 6379
    		protocol    = "tcp"
  	}

	  	ingress {
    		description = "SSH"
    		from_port   = 22
    		to_port     = 22
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]

  	}

	ingress {
			description = "ping-ICMP-port5"
			from_port   = -1
			to_port     = -1
			protocol    = "icmp"
			cidr_blocks = [ "0.0.0.0/0" ]
}

  	egress {
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
  	}

  	tags = {
    		Name = "private-blue"
        	}
}

resource "aws_security_group" "app-green" {
	name        = "green-sg"
  	description = "Disallow TLS inbound traffic"
  	vpc_id      = aws_vpc.MainVPC.id

  	ingress {
    		description = "public-port"
    		from_port   = 80
    		to_port     = 80
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}

  	ingress {
    		description = "redis-port"
    		from_port   = 6379
    		to_port     = 6379
    		protocol    = "tcp"
  	}

	  	ingress {
    		description = "SSH"
    		from_port   = 22
    		to_port     = 22
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]

  	}


		ingress {
			description = "ping-ICMP-port5"
			from_port   = -1
			to_port     = -1
			protocol    = "icmp"
			cidr_blocks = [ "0.0.0.0/0" ]
	}


  	egress {
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
  	}

  	tags = {
    		Name = "private-green"
        	}
}

