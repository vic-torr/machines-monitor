#!/bin/sh


mysql -u vektor < machinesdb_table_drop.sql

mysql -u vektor < machinesdb_table_create.sql

BASEDIR=$(dirname "$0") 
cd $BASEDIR

#ps -e -o %p, -o "fname", -o time -o,%C, -o %mem -o,%U, -o %c | tr -s '[:blank:]' ',' | sed 's/^.//g' > process.csv && cat process.csv
ps -e -o %p, -o fname -o,%C, -o %mem, -o ,%x -o,%U, -o %c | sed 's/^.//g' > process.csv
#cat process.csv

w -f| awk '(NR>1)' | tr -s '[:blank:]' ',' > users.csv

mac_addr=$(ifconfig | grep -m1 -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

ip_addr=$(ifconfig | grep -A 3 "wlp2s0" |grep -m2 -o -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)

mem_usage=$(awk -F"," '{x+=$3}END{print x}' ./process.csv)

cpu_usage=$(awk -F"," '{x+=$2}END{print x}' ./process.csv)
need_testing=1
is_up=1
ps_id=32
users_table_id=2
host_name=$(cat /proc/sys/kernel/hostname)

echo mac_addr,need_testing,is_up,ip_addr,host_name,cpu_usage,mem_usage > machine_table.csv
echo $mac_addr,$need_testing,$is_up,$ip_addr,$host_name,$cpu_usage,$mem_usage >> machine_table.csv


mysql -u vektor  < insert.sql
