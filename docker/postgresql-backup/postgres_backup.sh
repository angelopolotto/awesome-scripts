#!/bin/bash

# Referências
# https://stackoverflow.com/questions/2893954/how-to-pass-in-password-to-pg-dump
# https://www.linode.com/docs/databases/postgresql/how-to-back-up-your-postgresql-database/
# https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs
# Next Curl (nextcloud api upload file)
# https://help.nextcloud.com/t/uploading-files-through-api/51754
# https://docs.nextcloud.com/server/latest/user_manual/files/access_webdav.html#accessing-files-using-curl

# decide se usa arquivo local ou não através de argumentos
# ex: ./postgres_backup.sh env-dev.env
if [ ! -z "$1" ]; then
  echo "-> Usando arquivo ENV $1"
  # configura as variáveis de ambiente no modo debug
  export $(grep -v '^#' $1 | xargs -d '\n')
else
  echo "-> Usando ENV configurados no sistema"
fi

FILE_NAME="$DB_NAME"_"$(date '+%Y-%m-%dT%H:%M:%S')".bak

echo "-> Realizando o dump do banco de dados: $DB_HOST:$DB_PORT/$DB_NAME ..."
# obtém a senha
# faz o backup do banco e salva em um arquivo
PGPASSWORD=$DB_PASSWORD pg_dump -U $DB_USERNAME -h $DB_HOST -p $DB_PORT -d $DB_NAME >$FILE_NAME

echo "-> Enviando dados para o nextcloud: $NEXT_URL - pasta: $NEXT_FOLDER - usuário: $NEXT_USER ..."
curl -u $NEXT_USER:$NEXT_PASS -T $FILE_NAME "$NEXT_URL/remote.php/dav/files/$NEXT_USER/$NEXT_FOLDER/$FILE_NAME"

echo "-> Apagando arquivos gerados para o backup..."
#rm -r $FILE_NAME

if [ ! -z "$1" ]; then
  # remove as variáveis de ambiente no modo debug
  unset $(grep -v '^#' $1 | sed -E 's/(.*)=.*/\1/' | xargs)
fi

echo "-> Fim do backup"
