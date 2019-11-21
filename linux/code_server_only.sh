#!/bin/bash

# configuração
CODE_PORT=
export PASSWORD=


# download code server
CODE_URL=https://github.com/cdr/code-server/releases/download/2.1692-vsc1.39.2/code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz
CODE_FILE_NAME=code-server.tar.gz
CODE_FOLDER_NAME=code-server


wget -c "$CODE_URL" -O "$CODE_FILE_NAME"

mkdir -p "$CODE_FOLDER_NAME"
tar -zxvf "$CODE_FILE_NAME" --strip-components 1 -C ./"$CODE_FOLDER_NAME"

CODE_SERVER_BIN_PATH=$(pwd)/$CODE_FOLDER_NAME/code-server

$CODE_SERVER_BIN_PATH --cert --port "$CODE_PORT" &
