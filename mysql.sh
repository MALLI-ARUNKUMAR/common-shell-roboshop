#!/bin/bash
app_name=mysql

source ./common.sh

root_check

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing the mysql-server"

systemctl enable mysqld
systemctl start mysqld  &>>$LOG_FILE
VALIDATE $? "start and enable the mysqld"
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "assigning the password"
print_total_time_execution_of_script