FROM jenkins/jenkins:2.343

USER root

# installing docker
RUN apt update -y
RUN apt install -y docker.io && apt install -y vim

# adding aws
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip && ./aws/install

# add docker goup (+modify) to jenkins
RUN groupmod -g 998 docker
RUN usermod -a -G docker jenkins

USER jenkins