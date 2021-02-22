



CREATE TABLE IF NOT EXISTS machinesdb.machines (
    mac_addr TINYTEXT NOT NULL,
    need_testing boolean NOT NULL,
    is_up boolean NOT NULL,
    ip TINYTEXT NOT NULL,
    host_name TINYTEXT NOT NULL,
    cpu smallint NOT NULL,
    memory smallint NOT NULL,
    process_table_id smallint NOT NULL,
    users_table_id smallint NOT NULL,
    PRIMARY KEY (mac_addr(17))
);
CREATE TABLE IF NOT EXISTS machinesdb.processes (
    pid smallint NOT NULL,
    process_name text NOT NULL,
    cpu real NOT NULL,
    ram real NOT NULL,
    user_name TINYTEXT NOT NULL,
    process_time TINYTEXT NOT NULL,
    command text NOT NULL
    mac_addr TINYTEXT NOT NULL referenced machinesdb.machines(mac_addr),
    proc_tab_id TINYTEXT NOT NULL,
    PRIMARY KEY (proc_tab_id)
);




CREATE TABLE IF NOT EXISTS machinesdb.users (
    user_name TINYTEXT NOT NULL,
    tty TINYTEXT NOT NULL,
    login_at TINYTEXT NOT NULL,
    idle TINYTEXT NOT NULL,
    jcpu TINYTEXT NOT NULL,
    pcpu TINYTEXT NOT NULL,
    what TINYTEXT NOT NULL,
    mac_addr TINYTEXT NOT NULL referenced machinesdb.machines(mac_addr),
    proc_tab_id TINYTEXT NOT NULL,
    PRIMARY KEY (proc_tab_id)
);

CREATE INDEX machine_user ON machinesdb.users
    (mac_addr);

CREATE INDEX machine_process ON machinesdb.processes
    (mac_addr);