#!/bin/bash
app_name=catalogue

source ./common.sh
root_check 
app_setup
nodejs_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
VALIDATE $? "installing the mongodb"

Index=$(mongosh --host $MONGODB_HOST  --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $Index -le 0 ] ; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    VALIDATE $? "products is loading"
else
    echo -e "products already loaded....$Y skipping $N "
fi

restart_setup

print_total_time_execution_of_script