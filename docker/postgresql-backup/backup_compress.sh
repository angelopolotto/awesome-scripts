#!/bin/bash
# compacta o jar para facilitar o upload para Google Drive
tar -cvf backupdockerdeploy.tar captain-definition postgres_backup.sh entry.sh tasks.py requirements.txt
