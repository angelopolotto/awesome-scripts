#!/bin/bash

##########################
# script para instalar utilitários
# no servidor
##########################
# Referências:
# https://www.electrictoolbox.com/wget-save-different-filename/
# https://stackoverflow.com/questions/11362273/how-to-extract-tar-gz-on-current-directory-no-subfolder
# https://unix.stackexchange.com/questions/11018/how-to-choose-directory-name-during-untarring
# https://www.cyberciti.biz/faq/linux-unix-bsd-extract-targz-file/
# SSL
# https://superuser.com/questions/791218/can-i-use-another-port-other-than-443-for-ssl-communication
# code server
# https://github.com/cdr/code-server
# terminal web
# https://www.tecmint.com/gotty-share-linux-terminal-in-web-browser/
# https://www.tecmint.com/access-linux-server-terminal-in-web-browser-using-wetty/
# https://www.2daygeek.com/shellinabox-web-based-ssh-terminal-to-access-remote-linux-servers/
# caprover
# https://caprover.com/docs/get-started.html
# Password
# https://passwordsgenerator.net/
# deamon
# https://vpsfix.com/community/server-administration/no-etc-rc-local-file-on-ubuntu-18-04-heres-what-to-do/
# https://www.tecmint.com/run-linux-command-process-in-background-detach-process/
# bin exec
# https://askubuntu.com/questions/164180/different-ways-of-executing-binaries-and-scripts
# wget
# https://www.debyum.com/download-files-from-nextcloud-by-wget/

# eleveção para sudo
# exige o super usuário
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

# atualização do apt
apt -y update
apt -y upgrade

# instalação do docker
apt -y install docker.io

# configuração do firewall
ufw allow 80,443,3000,996,7946,4789,2377,"$CODE_PORT"/tcp; ufw allow 7946,4789,2377/udp;

# instalação do caprover
docker run -p 80:80 -p 443:443 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover

# instalação do code-server
# para facilitar a manutenção e interação com o servidor
wget -c "$CODE_URL" -O "$CODE_FILE_NAME"

# extração
mkdir -p "$CODE_FOLDER_NAME"
tar -zxvf "$CODE_FILE_NAME" --strip-components 1 -C ./"$CODE_FOLDER_NAME"

# configurando o code server para funcionar mesmo quando
# o sistema for reiniciado
CODE_SERVER_BIN_PATH=$(pwd)/$CODE_FOLDER_NAME/code-server

echo "
#!/bin/sh -e

# execução do code server em background
# certificado SSL auto assinado
# autenticação por senha
# configuração da porta
# funcionando como deamon (backgorund)
bash $CODE_SERVER_BIN_PATH --cert --port $CODE_PORT &

# configura para retornar sucesso (0)
exit 0
" > /etc/rc.local

chmod +x /etc/rc.local

# execução do code server em background
# certificado SSL auto assinado
# autenticação por senha
# configuração da porta
# funcionando como deamon (backgorund)
export $PASSWORD
$CODE_SERVER_BIN_PATH --cert --port "$CODE_PORT" &


if [ ! -z "$1" ]; then
  # remove as variáveis de ambiente
  unset $(grep -v '^#' $1 | sed -E 's/(.*)=.*/\1/' | xargs)
fi
