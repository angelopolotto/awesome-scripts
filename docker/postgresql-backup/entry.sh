#!/bin/sh

echo "$(date '+%Y-%m-%dT%H:%M:%S') -> #################### fazendo o primeiro backup ####################"
sh /scripts/postgres_backup.sh

echo "$(date '+%Y-%m-%dT%H:%M:%S') -> #################### iniciando tasks.py ####################"
python3 /scripts/tasks.py
