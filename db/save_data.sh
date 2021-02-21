#!/bin/sh
BASEDIR=$(dirname "$0") 
#script_path=$("$0" | sed '[^\/]+$')
echo $BASEDIR
cd $BASEDIR
pwd

ps_id=32
#ps -e -o %p, -o "fname", -o time -o,%C, -o %mem -o,%U, -o %c | tr -s '[:blank:]' ',' | sed 's/^.//g' > process.csv && cat process.csv
ps -e -o %p, -o fname -o,%C, -o %mem, -o ,%x -o,%U, -o %c | sed 's/^.//g' > process.csv && cat process.csv

w -f| awk '(NR>1)' | tr -s '[:blank:]' ',' > users.csv

mac_addr=$(ifconfig | grep -m1 -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

ip_addr=$(ifconfig | grep -A 3 "wlp2s0" |grep -m2 -o -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)

mem_usage=$(awk -F"," '{x+=$3}END{print x}' ./process.csv)

cpu_usage=$(awk -F"," '{x+=$2}END{print x}' ./process.csv)


host_name=$(cat /proc/sys/kernel/hostname)

echo echo mac_addr,need_testing,is_up,ip_addr,name,cpu,memory > machine_table.csv
echo $mac_addr,true,true,$ip_addr,$host_name,$cpu_usage,$mem_usage >> machine_table.csv