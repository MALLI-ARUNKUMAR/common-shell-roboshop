#!/bin/bash
app_name=user

source ./common.sh

root_check 
app_setup
nodejs_setup
systemd_setup
restart_setup
print_total_time_execution_of_script