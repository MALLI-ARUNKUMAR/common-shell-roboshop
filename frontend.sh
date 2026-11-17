#!/bin/bash
app_name=frontend
source ./common.sh
root_check

dnf module list nginx
dnf module disable nginx -y
dnf module enable nginx:1.24 -y
dnf install nginx -y
VALIDATE $? "installing the nginx"

systemctl enable nginx 
systemctl start nginx 
VALIDATE $? "start and enable the nginx"



rm -rf /usr/share/nginx/html/* 
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "copying the code"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "copying the nginx file"
systemctl restart nginx 
VALIDATE $? "restart the nginx"