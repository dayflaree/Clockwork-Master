
function PLUGIN:ClockworkDatabaseConnected()
	local CREATE_LOGS_TABLE = [[
	CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_logs_table"):Get()..[[` (
	`_Key` int(11) NOT NULL AUTO_INCREMENT,
	`_Text` text NOT NULL,
	`_UnixTime` int(11) NOT NULL,
	`_Day` int(11) NOT NULL,
	`_Month` int(11) NOT NULL,
	`_Year` int(11) NOT NULL,
	PRIMARY KEY (`_Key`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;]];
	
	Clockwork.database:Query(string.gsub(CREATE_LOGS_TABLE, "%s", " "), nil, nil, true);
end;

function PLUGIN:ClockworkLog(text, unixTime)
	if (!Clockwork.config:Get("database_logging_enabled"):Get()) then
		return;
	end;

	local logsTable = Clockwork.config:Get("mysql_logs_table"):Get();
	local dateInfo = os.date("*t", unixTime);

	local queryObj = Clockwork.database:Insert(logsTable);
		queryObj:SetValue("_Text", text);
		queryObj:SetValue("_UnixTime", unixTime);
		queryObj:SetValue("_Day", dateInfo.day);
		queryObj:SetValue("_Month", dateInfo.month);
		queryObj:SetValue("_Year", dateInfo.year);
	queryObj:Push();
end;