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
    PRIMARY KEY (mac_addr(17))
);


CREATE TABLE IF NOT EXISTS machinesdb.processes (
    pid smallint NOT NULL,
    process_time time NOT NULL,
    cpu real NOT NULL,
    ram real NOT NULL,
    user_name TINYTEXT NOT NULL,
    command text NOT NULL,
    name text NOT NULL
);


CREATE TABLE IF NOT EXISTS machinesdb.users (
    user_name TINYTEXT NOT NULL,
    tty TINYTEXT NOT NULL,
    login_at TINYTEXT NOT NULL,
    idle TINYTEXT NOT NULL,
    jcpu TINYTEXT NOT NULL,
    pcpu TINYTEXT NOT NULL,
    what TINYTEXT NOT NULL
);

