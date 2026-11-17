#!/bin/bash
app_name=payment
source ./common.sh
root_check
app_setup
python_setup
systemd_setup
restart_setup
print_total_time_execution_of_script