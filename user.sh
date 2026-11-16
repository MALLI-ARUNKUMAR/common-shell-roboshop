#!/bin/bash
app_name=user

source ./common.sh
script_started
root_check 
app_setup
nodejs_setup
systemd_setup
restart_setup
total_time