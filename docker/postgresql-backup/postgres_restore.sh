#!/bin/bash
# Script para fazer o restore dos dados do banco
# Ex: ./postgres_restore.sh sigct_dev_2019-11-06T15:20:32.bak env-dev.env

# Referências
# https://stackoverflow.com/questions/2893954/how-to-pass-in-password-to-pg-dump
# https://www.linode.com/docs/databases/postgresql/how-to-back-up-your-postgresql-database/
# https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs
# https://stackoverflow.com/questions/7073773/drop-postgresql-database-through-command-line

# obtém o nome o arquivo do backup para restore
if [ -z "$1" ]; then
  echo "-> Erro: Informe o nome do arquivo para restore como parametro, ex:"
  echo "-> ./postgres_restore.sh data_backup.bak"
  exit 1
fi

BACKUP_FILE=$1

echo "-> Restore do arquivo: $BACKUP_FILE"

# decide se usa arquivo local ou não através de argumentos
# ex: ./postgres_restore.sh data.bak env-dev.env
if [ ! -z "$2" ]; then
  echo "-> Usando arquivo ENV $2"
  # configura as variáveis de ambiente no modo debug
  export $(grep -v '^#' $2 | xargs -d '\n')
fi

# configura a senha
export PGPASSWORD=$DB_PASSWORD

echo "-> Drop do banco $DB_NAME"
echo "-> exclui o banco destino para evitar conflitos"
# exclui o banco destino para evitar conflitos
psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -c "drop database $DB_NAME"

echo "-> Criando novamente o banco: $DB_NAME"
# cria um banco novo com o nome configurado no ENV
psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -c "create database $DB_NAME"

echo "-> fazendo o restore do banco a partir do  arquivo: $BACKUP_FILE"
# faz o restore do banco a partir de um arquivo
psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME $DB_NAME <"$BACKUP_FILE"

if [ ! -z "$2" ]; then
  # remove as variáveis de ambiente no modo debug
  unset $(grep -v '^#' $2 | sed -E 's/(.*)=.*/\1/' | xargs)
fi
