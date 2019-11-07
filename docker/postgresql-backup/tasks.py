#!/bin/python
# coding=utf-8

import schedule
import time
from subprocess import call


# Referências:
# https://pypi.org/project/schedule/
# https://stackoverflow.com/questions/373335/how-do-i-get-a-cron-like-scheduler-in-python
# https://www.geeksforgeeks.org/python-schedule-library/

def postgres_backup_00_h():
    print("#################### inicio postgres_backup_00_h ####################")
    print("postgres_backup_60_min : {}".format(time.ctime()))
    try:
        call(['sh', '/scripts/postgres_backup.sh'])
    except Exception as e:
        print('problema ao executar postgres_backup.sh')
        print(e)

    print("#################### fim postgres_backup_60_min ####################")


if __name__ == "__main__":
    print("#################### tasks.py iniciado ####################")

    # Executa a tarefa postgres_backup_00_h() às 00:00.
    schedule.every().day.at("00:00").do(postgres_backup_00_h)

    while True:
        schedule.run_pending()
        time.sleep(1)
