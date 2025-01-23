--[[

- Edit the config below to match your MySQL server setup.
- Run the following on your MySQL host database to setup the table, BEFORE running this on a Garry's Mod server.
- Make sure you allow your Garry's Mod servers' IP address to access the MySQL server.

CREATE TABLE IF NOT EXISTS `globaldata` (
	`key` varchar(100) NOT NULL,
	`value` text NOT NULL
);

]]--

gdatadb_host = "127.0.0.1"
gdatadb_user = "root"
gdatadb_pass = ""
gdatadb_name = "gmod"
gdatadb_port = 3306

gdatasync_schedule = 30 -- How many seconds between syncing data from MySQL.
