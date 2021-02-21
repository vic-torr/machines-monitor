CREATE TABLE public.machine (
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

CREATE INDEX ON public.machine
    (process_table_id);
CREATE INDEX ON public.machine
    (users_table_id);


CREATE TABLE public.machine_processes (
    id smallint NOT NULL,
    machine_mac TINYTEXT NOT NULL,
    pid smallint NOT NULL,
    time time without time zone NOT NULL,
    cpu real NOT NULL,
    ram real NOT NULL,
    user_name TINYTEXT NOT NULL,
    command text NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX ON public.machine_processes
    (machine_mac);


CREATE TABLE public.users_info (
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

CREATE INDEX ON public.users_info
    (machine_mac);


ALTER TABLE public.machine ADD CONSTRAINT FK_machine__process_table_id FOREIGN KEY (process_table_id) REFERENCES public.machine_processes(id);
ALTER TABLE public.machine ADD CONSTRAINT FK_machine__users_table_id FOREIGN KEY (users_table_id) REFERENCES public.users_info(id);