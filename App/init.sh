
echo ### Installing Firefox ###

apt-get install software-properties-common
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6DCF7707EBC211F
apt-add-repository "deb http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu focal main"
apt update
apt install firefox