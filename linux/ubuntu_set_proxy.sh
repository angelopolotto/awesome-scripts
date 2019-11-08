#!/bin/bash

########################
# configuração do do proxy apt
# references:
# https://unix.stackexchange.com/questions/77277/how-to-append-multiple-lines-to-a-file
# https://unix.stackexchange.com/questions/28791/prompt-for-sudo-password-and-programmatically-elevate-privilege-in-bash-script
# https://www.cyberciti.biz/faq/unix-linux-export-variable-http_proxy-with-special-characters/
# snap
# https://stackoverflow.com/questions/50584084/snap-proxy-doesn%C2%B4t-work
# apt
# https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-set-the-proxy-for-apt-for-ubuntu-18-04/
# docker
# https://stackoverflow.com/questions/23111631/cannot-download-docker-images-behind-a-proxy
# maven
# https://www.javahelps.com/2015/08/set-proxy-for-maven-in-eclipse.html
# pip
# 
########################

# permissão para sudo
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# decide se usa arquivo local ou não através de argumentos
# ex: ./ubuntu_set_proxy.sh env-dev.env
if [ ! -z "$1" ]; then
  echo "-> Usando arquivo ENV $1"
  # configura as variáveis de ambiente no modo debug
  export $(grep -v '^#' $1 | xargs -d '\n')
else
  echo "-> informe o arquivo contendo as informações do proxy ex: ./ubuntu_set_proxy.sh env-dev.env"
  exit 1
fi

PROXY_URL_FORMATED="$PROXY_URL:$PROXY_PORT"
PROXY_USER_PASS="$PROXY_USER:$PROXY_PASS"
PROXY_CONFIG="http://$PROXY_USER_PASS@$PROXY_URL_FORMATED/"

echo "Configure proxies (snap/apt/git/maven/pip/docker)?"
read -p "option [c(configure)/r(remove)]: " OPT

case $OPT in
	c)
		####################################################
		#snap
		snap set system proxy.http=$PROXY_CONFIG
		snap set system proxy.https=$PROXY_CONFIG
		systemctl restart snapd
		
		# apt
		echo "
Acquire::http::Proxy \"$PROXY_CONFIG\";
Acquire::https::Proxy \"$PROXY_CONFIG\";
" >> /etc/apt/apt.conf.d/proxy.conf

		# git
		git config --global http.proxy $PROXY_CONFIG
		git config --global https.proxy $PROXY_CONFIG

		# maven
		mkdir -p ~/.m2/
		echo "
<settings>
<proxies>
 <!-- Proxy for HTTP -->
 <proxy>
  <id>optional</id>
  <active>true</active>
  <protocol>http</protocol>
  <username>$PROXY_USER</username>
  <password>$PROXY_PASS</password>
  <host>$PROXY_URL</host>
  <port>$PROXY_PORT</port>
  <nonProxyHosts>local.net</nonProxyHosts>
 </proxy>
 <!-- Proxy for HTTPS -->
 <proxy>
  <id>optional</id>
  <active>true</active>
  <protocol>https</protocol>
  <username>$PROXY_USER</username>
  <password>$PROXY_PASS</password>
  <host>$PROXY_URL</host>
  <port>$PROXY_PORT</port>
  <nonProxyHosts>local.net</nonProxyHosts>
 </proxy>
</proxies>
</settings>" >> ~/.m2/settings.xml
		
		# pip3
		mkdir -p ~/.config/pip/
		echo "
[global]
proxy = $PROXY_USER:$PROXY_PASS@$PROXY_URL:$PROXY_PORT
" >> ~/.config/pip/pip.conf

		# docker
		mkdir -p /etc/systemd/system/docker.service.d
		echo "
[Service]
Environment="HTTP_PROXY=http://$PROXY_URL_FORMATED"
" >> /etc/systemd/system/docker.service.d/http-proxy.conf
		systemctl daemon-reload
		systemctl restart docker
		####################################################
	;;

	r)
		####################################################
		# snap
		snap set system proxy.http=""
		snap set system proxy.https=""
		systemctl restart snapd

		# apt
		rm -r /etc/apt/apt.conf.d/proxy.conf
		
		# git
		git config --global http.proxy ""
		git config --global https.proxy ""
		
		# maven
		rm -r ~/.m2/settings.xml
		
		# pip3
		rm -r ~/.config/pip/

		# docker
		rm -r /etc/systemd/system/docker.service.d
		systemctl daemon-reload
		systemctl restart docker
		####################################################
	;;
	*)
		####################################################
		echo 'invalid option...'
		exit
		####################################################
	;;
esac

echo "####################################################"
echo "checking snap proxy config: "
snap get system proxy.http
snap get system proxy.https
echo "####################################################"

echo "####################################################"
echo "checking apt config file (/etc/apt/apt.conf.d/proxy.conf):"
cat /etc/apt/apt.conf.d/proxy.conf
echo "####################################################"

echo "####################################################"
echo "checking git proxy config:"
git config --global http.proxy
git config --global https.proxy
echo "####################################################"

echo "####################################################"
echo "checking maven config file (~/.m2/settings.xml):"
cat ~/.m2/settings.xml
echo "####################################################"

echo "####################################################"
echo "checking pip config file (~/.config/pip/pip.conf):"
cat ~/.config/pip/pip.conf
echo "####################################################"

echo "####################################################"
echo "checking docker config file (/etc/systemd/system/docker.service.d/http-proxy.conf):"
systemctl show --property Environment docker
cat /etc/systemd/system/docker.service.d/http-proxy.conf
echo "####################################################"

if [ ! -z "$1" ]; then
  # remove as variáveis de ambiente no modo debug
  unset $(grep -v '^#' $1 | sed -E 's/(.*)=.*/\1/' | xargs)
fi
