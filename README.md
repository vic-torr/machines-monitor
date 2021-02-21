 
PART 1: Web Development & Automation
=====================================


1)
A DB model can be designed by a ER model. The machine can modeled as strong entities, by each one having a unique identifier, which is MAC address. The process table, and users tables are weak entities, with cardinality 1:1.


Machine

Attibutes:  
MAC addr,IP, host Name, Status, Is up, Logged Users, Running Process table, CPU usage,  Memory Usage  

Process table:
PID, Process name, CPU usage, Memory usage, time usage, command

User:
User name, cpu usage, login at machine, idle 

![ER](./imgs/ER_MODEL.png)


b)


c) 

A simpler implementation, but less scalable and works mostly to local nework: the monitor machine update the machines periodically by a poll. To each machine, is executed a bash script which connects by ssh, execute each command and retrieve a txt report file with each one of them. After get all files, a parse must be done, and then updating the DB.  

The pooling background process it can be implemented by the following commands:  


Process to Comands:
The list of current machines connected at local network can be retrieved by:  
```
arp -vn
```
Generating users table:

```
w -f| awk '(NR>1)' | tr -s '[:blank:]' ',' > users.csv
```
![ER](./imgs/users_csv.png)

Generating process table:

```
ps -e -o %p, -o fname -o,%C, -o %mem, -o ,%x -o,%U, -o %c | sed 's/^.//g' > process.csv
```
![ER](./imgs/process_csv.png)


Current machine total CPU usage:

```
cpu_usage=$(awk -F"," '{x+=$2}END{print x}' ./process.csv)
```

Current machine total MEM usage:

```
mem_usage=$(awk -F"," '{x+=$3}END{print x}' ./process.csv)
```
 


MAC address:
```
mac_addr=$(ifconfig | grep -m1 -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
```

IP address:
```
ip_addr=$(ifconfig | grep -A 3 "wlp2s0" |grep -m2 -o -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)

```

HostName:
```
host_name=$(cat /proc/sys/kernel/hostname)
```

Store MachineTable headers:
```
echo mac_addr,need_testing,is_up,ip_addr,host_name,cpu_usage,mem_usage > machine_table.csv
echo $mac_addr,$need_testing,$is_up,$ip_addr,$host_name,$cpu_usage,$mem_usage >> machine_table.csv
```
![ER](./imgs/machines_csv.png)



The sql scrpit "insert.sql" updates database with csv files data:

```
LOAD DATA LOCAL INFILE './machine_table.csv' 
INTO TABLE machinesdb.machines
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 


LOAD DATA LOCAL INFILE './process.csv' 
INTO TABLE machinesdb.processes
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 


LOAD DATA LOCAL INFILE './users.csv' 
INTO TABLE machinesdb.users
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 
```
![ER](./imgs/process_db.png)


The background process required is stored at background_process.sh.
It uses ssh to connect to each machine, execute the former listed commands, and retrieve the each table of the machine, using ssh copy "scp":

```
#!/bin/bash

# Exit trap:

function trap_ctrlc() {

    exit 2
}

# Initialize tables:
mysql -u vektor < machinesdb_table_drop.sql
mysql -u vektor < machinesdb_table_create.sql

machines_list={192.168.1.32, 192.168.1.52}

while :
do

wait(60)

for machine in {machines_list}:
ssh -i "{machine}_key.pem" $machine /bin/bash << EOF
    # Get process table:
    ps -e -o %p, -o fname -o,%C, -o %mem, -o ,%x -o,%U, -o %c | sed 's/^.//g' > process.csv
    
    # Get users stats
    w -f| awk '(NR>1)' | tr -s '[:blank:]' ',' > users.csv
    
    # Get machine stats
    
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
EOF
scp -i "key_file.pem" $machine_addr: ~/machine_table.csv machine_table_${machine}.csv
scp -i "key_file.pem" $machine_addr: ~/process.csv process_${machine}.csv
scp -i "key_file.pem" $machine_addr: ~/users.csv users_${machine}.csv

mysql -u vektor  < insert.sql

done
```



A second but not discussed implementation, but with higher scalability and robustness could be implemented this way:
It can be implemented by a 2 modules: a centralized db, which runs at the monitor machine; and a daemon running in each machine to be monitored. The last one waits for a GET request. When it's sinalized, it answer, executing a POST request to the DB machine/API, retrieving a JSON with the previous information.
# 2)
The decision if a task must be automated or not relies on the difference of time cost to automate it, versus the acumulated time consumed on repeating this task.
If a task isnt usual, or dont consumes much time, users can even don't use the automation. 
So, when working with daily scheduled task, which spends more than 1 minutes,  5 times is enough to decide whether implement automation or not.



# 3) Conteiners

I would proceed using Conteiners, to encapsulate the application to the compatible kernel. The migration plan would be installing docker, set up MySQL8 in the conteiner. The former database need to be backed-up, exporting all the data to inside the database inside the conteiner.



PART 2: Python
==========================



4.)
======================



