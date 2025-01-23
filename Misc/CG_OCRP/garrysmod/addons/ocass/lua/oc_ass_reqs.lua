MySQLLoaded = true

require("tmysql")
tmysql.initialize("localhost", "root", "", "ocrp", 3306) 
SiteDatabaseConnection = 1

require("mysql")
ForumDatabase = mysql.connect("localhost", "root", "", "smf", 3306);
mysql.query(ForumDatabase, "SET wait_timeout=86400")
//mysql.query(ForumDatabase, "SET connect_timeout=86400")
/*function ConnectToMySQL ( )

	if SiteDatabaseConnection == 0 then
		if !file.Exists("mysql_fail_log.txt") then file.Write("mysql_fail_log.txt", ""); end
		file.Write("mysql_fail_log.txt", file.Read("mysql_fail_log.txt") .. "MySQL connection failed with reason '" .. MySQLError .. "'\n");
		
		for k, v in pairs(player.GetAll()) do
			RunConsoleCommand("kickid", v:UserID(), "MySQL Connection Error");
		end
		
		return false;
	else
		Msg("Successfully connect to MySQL database.\n");
	end
end

if !SiteDatabaseConnection then ConnectToMySQL() end*/



