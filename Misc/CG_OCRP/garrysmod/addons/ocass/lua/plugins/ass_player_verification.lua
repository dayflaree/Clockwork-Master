local PLUGIN = {}

PLUGIN.Name = "Default Writer2ds"
PLUGIN.Author = "Andy Vincent"
PLUGIN.Date = "09th August 2007"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = false
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2
PLUGIN.Gamemodes = {}

if !SERVER then return false; end
local res = {}
local bool = false
require("gatekeeper")
/*function callbacka( r, s, e )
	res = r
	bool = true
end

local function JoinAuth ( Name, Pass, SteamID, IP )	
	print("HI1")
	Msg('Gatekeeper: ' .. Name .. ' joined with IP ' .. IP .. ' and STEAMID of '.. SteamID ..'\n');
	local res = {}
	tmysql.query("SELECT `UNBAN` FROM `bans` WHERE `ID`='" .. SteamID .. "'", callbacka)


	bool = false
	print("HI3")
	print("##########")
	PrintTable(res)
	print("---------------")
	print(#res)
	print("##########")
	if #res != 0 then
	print("HI4")
		local Time = os.time();
		local UnbanTime = tonumber(res[1][1]);
	
		if UnbanTime == 0 then
	print("HI5")
			return false
		elseif UnbanTime < Time then
	print("HI6")
			MySQLQuery(SiteDatabaseConnection, "DELETE FROM `bans` WHERE `ID`='" .. SteamID .. "'");
		elseif UnbanTime >= Time then
	print("HI7")
			local TimeLeft = UnbanTime - os.time();
			local FormattedTime = string.FormattedTime(UnbanTime - os.time());
			
			local Minutes = math.floor(TimeLeft / 60);
			local Minutes2 = math.floor(TimeLeft / 60);
			local Seconds = TimeLeft - (Minutes * 60);
			local Hours = math.floor(Minutes / 60);
			local Minutes = Minutes - (Hours * 60);
			local Days = math.floor(Hours / 24);
			local Hours = Hours - (Days * 24);
			
			if Minutes == 0 then
	print("HI8")
				return false
			elseif Hours == 0 then
	print("HI9")
				return false
			elseif Days == 0 then
	print("HI10")
				return false
			else
	print("HI11")
				return false
			end
		end
	end
	return
end
hook.Add("PlayerPasswordAuth", "PlayerAuthentication", JoinAuth)*/

function DoServerMaxOCRP()
	if !gatekeeper then return end
	local clients = gatekeeper.GetNumClients() 
	if clients.total > 44 then
		RunConsoleCommand( "hostname", "Orange Cosmos Roleplay | #7 | Catalyst-Gaming.net" )
	else
		RunConsoleCommand( "hostname", "Orange Cosmos Roleplay | #7 | Catalyst-Gaming.net" )
	end
end
hook.Add("Think", "DoServerMaxOCRP", DoServerMaxOCRP)

ASS_RegisterPlugin(PLUGIN)
