 
PART 1: Web Development & Automation
=====================================


## 1)
A DB model can be designed by a ER model. The machine can modeled as strong entities, by each one having a unique identifier, which is MAC address. The process table, and users tables are weak entities, with cardinality 1:1.


## Machine
  
MAC addr, IP, host Name, Status, Is up, Logged Users, Running Process table, CPU usage,  Memory Usage  

## Process table:
PID, Process name, CPU usage, Memory usage, time usage, command

## User:
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
## Generating users table:

```
w -f| awk '(NR>1)' | tr -s '[:blank:]' ',' > users.csv
```
![ER](./imgs/users_csv.png)

## Generating process table:

```
ps -e -o %p, -o fname -o,%C, -o %mem, -o ,%x -o,%U, -o %c | sed 's/^.//g' > process.csv
```
![ER](./imgs/process_csv.png)




# Current machine statistics:

- Total CPU usage:

```
cpu_usage=$(awk -F"," '{x+=$2}END{print x}' ./process.csv)
```

- Current machine total MEM usage:

```
mem_usage=$(awk -F"," '{x+=$3}END{print x}' ./process.csv)
```
 


- MAC address:
```
mac_addr=$(ifconfig | grep -m1 -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
```

- IP address:
```
ip_addr=$(ifconfig | grep -A 3 "wlp2s0" |grep -m2 -o -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)

```

- HostName:
```
host_name=$(cat /proc/sys/kernel/hostname)
```

- Store machines table:
```
echo mac_addr,need_testing,is_up,ip_addr,host_name,cpu_usage,mem_usage > machine_table.csv
echo $mac_addr,$need_testing,$is_up,$ip_addr,$host_name,$cpu_usage,$mem_usage >> machine_table.csv
```
![ER](./imgs/machines_csv.png)



## Sql scripit "insert.sql" updates database with csv files data:

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
- Database snapshot:
![ER](./imgs/process_db.png)

## d) Background process
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

<br /> 
<br /> 

PART 2: Python
==========================
<br /> 

# 4)


A password validator was implemented finding all the characters which matches the pattern corresponding to input requirements. After filter characters, join all of them, and check if it matches with the specified length.
The source code and unitests are at pass validator directory.

Source:
```
#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import re

def validator_regex(password, requirements):
    """
    Find all the characters which matches the pattern
    corresponding to input requirements. 
    After filter characters, join all of them,
    and check if it matches with the specified length.


    Args:
        password (str): Password to be validated.
        requirements (List[tuple]): List of rules.

    Returns:
        [bool]: True if password satisfies requirements.
    """
    does_pass=True
    for n_req in requirements:
        (operation, comparation, length) = n_req
        size = {
            '<': r"{,"+rf"{length-1}" + r"}",
            '>': r"{"+ rf"{length+1}"+ r",}",
            '=': r"{"+ rf"{length},"+f"{length}"+r"}"
        }
        req_dict = {
            "LEN": r".",
            "SPECIALS": r"[^a-zA-Z0-9]",
            "LETTERS": r"[a-zA-Z]",
            "NUMBERS": r"[0-9]",
        }
        rule_char = "("+req_dict[operation]+")"
        rule_size = (
            "("+req_dict[operation]+size[comparation]+")")
        match = ''.join(re.findall(rule_char,password))
        match = re.fullmatch(rule_size,match)
        match = "" if match == None else match.string
        does_pass = (does_pass 
            and match != None and match != "")
           
    return does_pass


```

Tests:
```
import pytest
from pass_validator import validator_regex
validator=validator_regex

def test_len_gt_fail():
    req = [('LEN', '=', 8), ('SPECIALS', '>', 1)]
    assert validator("12345678!@", req) == False

def test_validator_len_eq_ok():
    req = [('LEN', '=', 8), ('SPECIALS', '>', 1)]
    assert validator("@23a567!", req) == True

def test_spectial_count():
    req = [('LEN', '>', 8), ('SPECIALS', '>', 1), ('LEN', '<', 10)]
    assert validator("123@4567!", req) == True

def test_validator_gtr():
    req = [('LEN', '>', 8), ('SPECIALS', '>', 1), ('LEN', '<', 10)]
    assert validator("1234567981!", req) == False

def test_validator_eq():
    req = [('LEN', '>', 8), ('SPECIALS', '>', 1), ('LEN', '<', 10)]
    assert validator("123@567!81", req) == False

def test_validator_letters():
    req = [('LETTERS', '>', 2), ('SPECIALS', '>', 1), ('LEN', '<', 10)]
    assert validator("1abc@567!", req) == True

```

![Pytest](./imgs/pytest.png)


<br /> 
<br /> 
<br /> 

 PART 3: Quality Assurance
=============================
5.)
=============================
The main way to guarantee that no new code can affect already implemented features is by using automated tests. They can be unit tests or automated structural tests. They must be executed whenever a new commit is done to the main branch. 


<br /> 
<br /> 

PART 4: Logic, Common Sense and Scripting
=============================
6.)
=============================

A simple algorithm was choosen to control the elevator. It assumes  a uniform distribuition of requests and destinations between the floors:

- The elevator has Capacity of X peoples.
 
- As long as there’s someone inside or ahead of the elevator who wants to go in the current direction, keep heading in that direction.

- Once the elevator has exhausted the requests in its current direction, switch directions if there’s a request in the other direction, if it's not compleately loaded yet. Otherwise, stop and wait for a call.

Test 0: No one requested. Stay at current floor.

Test 1: 
One person requesting elevator. The elevator is idle, then it must go imediately to the requested floor.

Test 2: 
One person requesting elevator already in use. The elevator is in the way of requested floor, it must stop at the requested floor.

Test 3: 
One person requesting elevator already in use. If the elevator is NOT in the way of requested floor, so it must switch direction to the requested floor.

Test 4: 
X+1 persons requesting elevator to go to ground floor. It must atend X peoples THEN fetch the last one.

Test 5: 
X persons curret in the elevator. It must stop whenever reaches a requested destination floor.


<br /> 
<br /> 

7.)
=============================
a)
It's implementation similar to insertion sort algorithm. It sorts in crescent order.

b) Output:
```
5 6 8 12 34 35 38 44 55
```

c) The while loop shifts a large amount of the array whenever finds a smaller $val. It has complexity order of $O(n^2)$ of swapings and comparations.
