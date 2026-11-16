#!/bin/bash

source ./common.sh
 --------------------script started  exection $(time_stamp) time ---------
root_check


cp mongo.repo /etc/yum.repos.d/mongo.repo >>$LOG_FILE
VALIDATE $?  "copying the mongo.repo file"

dnf install mongodb-org -y >>$LOG_FILE
VALIDATE $?  "installing MongoDB"

systemctl enable mongod >>$LOG_FILE
VALIDATE $? "enabling MongoDB"

systemctl start mongod >>$LOG_FILE
VALIDATE $? "starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0 /g' /etc/mongod.conf >>$LOG_FILE
VALIDATE $? "updating the bind_ip in mongod.conf"

systemctl restart mongod >>$LOG_FILE
VALIDATE $? "restarting MongoDB"

--------------------script completed  exection $(time_stamp) time ---------