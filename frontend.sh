#!/bin/bash
app_name=frontend
source ./common.sh
root_check
dnf module disable nginx -y 
dnf module enable nginx:1.24 -y 
dnf install nginx -y 
VALIDATE $? "Installing Nginx"

systemctl enable nginx  

systemctl start nginx 
VALIDATE $? "Enabled and started nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Remove default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip 
VALIDATE $? "Downloaded and unzipped frontend"

rm -rf /etc/nginx/nginx.conf 

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf 
VALIDATE $? "Copied our nginx conf file"

systemctl restart nginx 
VALIDATE $? "Restarted Nginx"