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