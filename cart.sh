#!/bin/bash
app_name=cart

source ./common.sh
script_started
root_check 
app_setup
nodejs_setup
systemd_setup
restart_setup
print_total_time_execution_of_script