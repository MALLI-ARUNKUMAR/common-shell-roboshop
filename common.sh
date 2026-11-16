#!/bin/bash

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOG_FILE="$LOGS_FOLDER/$0.log"

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
time_stamp() {
    date "+%Y-%m-%d_%H-%M-%S"
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