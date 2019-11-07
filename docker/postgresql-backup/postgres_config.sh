#!/bin/bash

# Referências:
# https://computingforgeeks.com/install-postgresql-12-on-ubuntu/
# Alpine config
# https://stackoverflow.com/questions/51192713/how-to-make-curl-available-in-docker-image-based-java8-jdk-alpine-and-keep-the/51209115
# https://dev.to/umeshdhakar/auto-backup-of-databases-in-postgres-container-4p56
# Crontab container
# https://medium.com/@allanlei/running-cron-in-docker-the-easy-way-4f779bfa9ca7
# https://stackoverflow.com/questions/37015624/how-to-run-a-cron-job-inside-a-docker-container
# Postgresql alpine
# https://stackoverflow.com/questions/40628472/can-i-install-pg-dump-without-installing-postgres-on-alpine

# adiciona os repositórios do pg client
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# atualiza os repositórios
apt update

# instala o cliente posgresql
apt -y install postgresql-client-12

# instala as ferramentas para backup
apt -y install postgresql-client-common

# atualiza o sistema
apt upgrade
