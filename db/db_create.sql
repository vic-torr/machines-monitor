-- Database: machinesdb
-- Author: machinesdb
CREATE DATABASE IF NOT EXISTS machinesdb
    WITH OWNER = postgres
        ENCODING = 'UTF8'
        TABLESPACE = machinesdb
        LC_COLLATE = 'undefined'
        LC_CTYPE = 'undefined'
        CONNECTION LIMIT = -1;

COMMENT ON DATABASE machinesdb
    IS 'machinesdb';