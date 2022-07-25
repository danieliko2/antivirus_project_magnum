provider "aws"{
    region = "eu-central-1"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

variable aws_access_key {}
variable aws_secret_key {}

resource "aws_vpc" "av-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "basic-av-vpc"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.av-vpc.id

}

resource "aws_route_table" "av-route-table" {
  vpc_id = aws_vpc.av-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "production"
  }
}

resource "aws_subnet" "subnet-1" {
    vpc_id     = aws_vpc.av-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-central-1c"

    tags = {
        Name = "av-subnet"
    }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.av-route-table.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.av-vpc.id

  ingress {
    description      = "HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}


resource "aws_network_interface" "web-server-nic" {

  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}

resource "aws_instance" "av_ci_ec2" {
    ami           = "ami-065deacbcaac64cf2"
    instance_type = "t2.micro"
    availability_zone = "eu-central-1c"
    key_name = "main-pair"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web-server-nic.id
    }
    
    user_data = <<-EOF
                  #!/bin/bash
                  echo ========== updating ==========
                  sudo apt update && sudo apt upgrade && sudo apt autoremove
                  echo ========== installing docker ==========
                  sudo apt install docker
                  echo ========== installing docker-compose ==========
                  sudo apt install docker-compose
                  echo ========== installing gnupg2 ==========
                  sudo apt -V install gnupg2 pass
                  echo ========== clearnig system ==========
                  sudo docker system prune -a -f
                  docker container rm -a -f
                  docker image rm -a -f
                  echo ========== loging-in ==========
                  aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-central-1.amazonaws.com
                  echo ========== pulling images ==========
                  cd tar
                  tag=$(cat tagcnf)
                  sudo docker pull 644435390668.dkr.ecr.eu-central-1.amazonaws.com/lavagna_backend:$tag
                  sudo docker pull 644435390668.dkr.ecr.eu-central-1.amazonaws.com/lavanga_sql:$tag
                  sudo docker pull 644435390668.dkr.ecr.eu-central-1.amazonaws.com/lavagna_proxy:$tag
                  sudo docker pull 644435390668.dkr.ecr.eu-central-1.amazonaws.com/lavagna_documentation:$tag
                  echo ========== building app ==========
                  sudo env_tag=$tag docker-compose up --build
                  EOF
    tags = {
        Name = "ec2_ubuntu"
    }

}
