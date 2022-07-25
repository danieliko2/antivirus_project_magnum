FROM python:3.10
COPY /App /App
WORKDIR /App

# CMD [ "./init.sh; sleep 10000" ]
RUN apt update

RUN apt-get -y install software-properties-common
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6DCF7707EBC211F
RUN apt-add-repository "deb http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu focal main"
RUN apt update
RUN apt install -y firefox
RUN pip install pip==22.1.2
RUN pip install -r requirements.txt


CMD [ "sleep 1000" ]