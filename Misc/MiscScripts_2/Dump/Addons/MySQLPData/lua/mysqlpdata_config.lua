--[[

- Edit the config below to match your MySQL server setup.
- Run the following on your MySQL host database to setup the table, BEFORE running this on a Garry's Mod server.
- Make sure you allow your Garry's Mod servers' IP address to access the MySQL server.

CREATE TABLE IF NOT EXISTS `playerdata` (
	`uniqueid` varchar(20) NOT NULL,
	`key` varchar(100) NOT NULL,
	`value` text NOT NULL
);

]]--

pdatadb_host = "127.0.0.1"
pdatadb_user = "root"
pdatadb_pass = ""
pdatadb_name = "gmod"
pdatadb_port = 3306

pdatasync_schedule = 30 -- How many seconds between syncing data from MySQL to local SQL database.
