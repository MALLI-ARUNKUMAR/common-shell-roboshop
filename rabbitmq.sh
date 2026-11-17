#!/bin/bash
app_name=rabbitmq
source ./common.sh
root_check

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "coping the repo"

dnf install erlang rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "installling the rabbitmq server"

systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server
VALIDATE $? "start and enable the rabbit mq"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "setting the permission"

print_total_time_execution_of_script