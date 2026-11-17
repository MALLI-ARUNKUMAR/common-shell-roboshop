#!/bin/bash
app_name=frontend
source ./common.sh
root_check
nginx_setup
frontend_appsetup

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf 
VALIDATE $? "Copied our nginx conf file"

restart_setup
print_total_time_execution_of_script