CREATE TABLE IF NOT EXISTS machinesdb.machine (
    mac_addr TINYTEXT NOT NULL,
    need_testing boolean NOT NULL,
    is_up boolean NOT NULL,
    ip TINYTEXT NOT NULL,
    name TINYTEXT NOT NULL,
    cpu smallint NOT NULL,
    memory smallint NOT NULL,
    process_table_id smallint NOT NULL,
    users_table_id smallint NOT NULL,
    PRIMARY KEY (mac_addr)
);




CREATE TABLE IF NOT EXISTS machinesdb.machine_processes (
    id smallint NOT NULL,
    machine_mac TINYTEXT NOT NULL,
    pid smallint NOT NULL,
    process_time time NOT NULL,
    cpu real NOT NULL,
    ram real NOT NULL,
    user_name TINYTEXT NOT NULL,
    command text NOT NULL,
    PRIMARY KEY (id)
);




CREATE TABLE IF NOT EXISTS machinesdb.users_info (
    id smallint NOT NULL,
    machine_mac TINYTEXT NOT NULL,
    user_name TINYTEXT NOT NULL,
    tty TINYTEXT NOT NULL,
    login_at TINYTEXT NOT NULL,
    idle TINYTEXT NOT NULL,
    jcpu TINYTEXT NOT NULL,
    pcpu TINYTEXT NOT NULL,
    what TINYTEXT NOT NULL,
    PRIMARY KEY (id)
);


ALTER TABLE machinesdb.machine ADD CONSTRAINT FK_machine__process_table_id FOREIGN KEY (process_table_id) REFERENCES machinesdb.machine_processes(id);
ALTER TABLE machinesdb.machine ADD CONSTRAINT FK_machine__users_table_id FOREIGN KEY (users_table_id) REFERENCES machinesdb.users_info(id);




CREATE INDEX user_machine ON machinesdb.users_info
    (machine_mac(17));
CREATE INDEX process_machine ON machinesdb.machine_processes
    (machine_mac(17));
CREATE INDEX machine_process ON machinesdb.machine
    (process_table_id;
CREATE INDEX machine_user ON machinesdb.machine
    (users_table_id;