#!/bin/bash

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOG_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.daws880s.online"
MYSQL_HOST=mysql.daws880s.online

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

root_check (){
if [ $USER_ID -ne 0 ] ; then
    echo "you are not root user. Please run the script as root user"
    exit 1
fi
}

script_started=$(date +%s)



time_stamp() {
    date '+%Y-%m-%d_%H-%M-%S'
}

mkdir -p $LOGS_FOLDER

VALIDATE () {
    if [ $1 -ne 0 ]; then
        echo  " $(time_stamp) | $2 .... FAILURE " | tee -a $LOG_FILE
        exit 1
    else
        echo  " $(time_stamp) |$2 .... SUCCESS " | tee -a $LOG_FILE
    fi 
}
nodejs_setup () {
dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disabling the nodejs module"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enabling the nodejs module"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "installing nodejs"

npm install &>>$LOG_FILE
VALIDATE $? "installing nodejs dependencies"

}
java_setup () {
dnf install maven -y &>>$LOG_FILE
VALIDATE $? "installing the maven"  
mvn clean package &>>$LOG_FILE
VALIDATE $? "installing the packages"

mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
VALIDATE $? "renaming the file name"
}
python_setup () {
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
VALIDATE $? "installing the python version"  
pip3 install -r requirements.txt
VALIDATE $? "Creating virtual environment"
}
nginx_setup () {
dnf module disable nginx -y 
dnf module enable nginx:1.24 -y 
dnf install nginx -y 
VALIDATE $? "Installing Nginx"

systemctl enable nginx  

systemctl start nginx 
VALIDATE $? "Enabled and started nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Remove default content"
}
frontend_appsetup () {
curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
cd /usr/share/nginx/html 
unzip /tmp/$app_name.zip 
VALIDATE $? "Downloaded and unzipped $app_name"

rm -rf /etc/nginx/nginx.conf 
}
app_setup () {
id roboshop &>>$LOG_FILE
if [ $? -ne 0 ] ; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "creating roboshop user"
else
    echo "roboshop user already exists, skipping"
fi    

mkdir -p /app  &>>$LOG_FILE
VALIDATE $? "creating /app directory"

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip 
VALIDATE $? "downloading $app_name zip file"

cd /app &>>$LOG_FILE
VALIDATE $? "changing directory to app"

rm -rf /app/* &>>$LOG_FILE
VALIDATE $? "Removing the exisiting code"

unzip -o /tmp/$app_name.zip &>>$LOG_FILE
VALIDATE $? "unzipping $app_name zip file"

cd /app 
VALIDATE $? "changing directory to app"

}

systemd_setup (){
cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service 
VALIDATE $? "creating the systemctl service"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "daemon-reload"

systemctl enable $app_name 
VALIDATE $? "enabling the $app_name"

systemctl start $app_name
VALIDATE $? "start the $app_name"
}

restart_setup (){
systemctl restart $app_name
VALIDATE $? "restating the $app_name" 
}

print_total_time_execution_of_script() {
    script_finished=$(date +%s)

    total_time=$((script_finished - script_started))

    echo "$(time_stamp) | Script execution time: $total_time seconds"
}
