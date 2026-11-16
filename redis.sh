#!/bin/bash
app_name=redis

source ./common.sh

root_check



dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "disbale the default version redis version"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enabling the redis 7 version"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "installing the redis "

sed -i -e 's/127.0.0.1/0.0.0.0/g'  -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "enabling the remote connection"

systemctl restart redis  &>>$LOG_FILE
VALIDATE $? "restart the redis"

print_total_time_execution_of_script