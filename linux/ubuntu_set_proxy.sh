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
########################

# permissão para sudo
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# unum '@:!#$'
# replace 0x for %
# Octal  Decimal      Hex        HTML    Character   Unicode
# 0100       64     0x40       @    "@"         COMMERCIAL AT
# 072       58     0x3A       :    ":"         COLON
# 041       33     0x21       !    "!"         EXCLAMATION MARK
# 043       35     0x23       #    "#"         NUMBER SIGN
# 044       36     0x24       $    "$"         DOLLAR SIGN
PROXY_URL_ONLY='someurl.corp'
PROXY_PORT='3128'
PROXY_USER='some.user'
PROXY_PASS='some.password'

PROXY_URL="$PROXY_URL_ONLY:$PROXY_PORT"
PROXY_USER_PASS="$PROXY_USER:$PROXY_PASS"
PROXY_CONFIG="http://$PROXY_USER_PASS@$PROXY_URL/"

echo "Configure proxies (apt/snap/git)?"
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
  <host>$PROXY_URL_ONLY</host>
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
  <host>$PROXY_URL_ONLY</host>
  <port>$PROXY_PORT</port>
  <nonProxyHosts>local.net</nonProxyHosts>
 </proxy>
</proxies>
</settings>" >> ~/.m2/settings.xml
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
