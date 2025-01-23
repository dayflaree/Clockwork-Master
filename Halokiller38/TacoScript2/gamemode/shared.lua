team.SetUp( 1, "Citizens", Color( 0, 120, 0, 255 ) );
team.SetUp( 2, "Civil Protection", Color( 38, 107, 255, 255 ) );
team.SetUp( 3, "Combine Overwatch", Color( 222, 92, 0, 255 ) );
team.SetUp( 4, "City Administration", Color( 222, 0, 0, 255 ) );
team.SetUp( 5, "Vortigaunts", Color( 99, 207, 44, 255 ) );

TS = { }

TS.Spawns = {};

TS.Spawns["rp_c18_v1"] =
{
	x = 1421;
	y = 1060;
	z = 512;
}

TS.Spawns["rp_city8"] =
{
	x = -2323;
	y = 2181;
	z = -96;
}


TS.Spawns["rp_canals_final_fix"] =
{
	x = 3215;
	y = -3676;
	z = 256;
}

TS.Spawns["rp_tb_city45_v02n"] =
{
	x = 1183;
	y = 1516;
	z = 576;
}


TS.MapViews = { }

TS.MapViews["rp_c18_v1"] =
{
	pos = Vector( -196, -714, 826 );
	ang = Angle( -27, 138, 0 );
}

TS.MapViews["rp_city8"] =
{
	pos = Vector( 1355, 528, 230 );
	ang = Angle( 50, 46, 0 );
}

TS.MapViews["rp_canals_final_fix"] =
{
	pos = Vector( 3375, 2250, 412 );
	ang = Angle( 31, -60, 0 );
}

TS.MapViews["rp_tb_city45_v02n"] =
{
	pos = Vector( -71, 2109, 240 );
	ang = Angle( -38, -4, 0 );
}

TS.ItemsData = { }

TS.MaxInventories = 1;
MAX_CHARACTERS = 16;

TS.HUDItemInfo = { }

TS.SelectablePlayerModels =
{
	"models/Humans/Group01/Male_01.mdl",
	"models/Humans/Group01/male_02.mdl",
	"models/Humans/Group01/male_03.mdl",
	"models/Humans/Group01/Male_04.mdl",
	"models/Humans/Group01/Male_05.mdl",
	"models/Humans/Group01/male_06.mdl",
	"models/Humans/Group01/male_07.mdl",
	"models/Humans/Group01/male_08.mdl",
	"models/Humans/Group01/male_09.mdl",
	"models/Humans/Group02/Male_01.mdl",
	"models/Humans/Group02/male_02.mdl",
	"models/Humans/Group02/male_03.mdl",
	"models/Humans/Group02/Male_04.mdl",
	"models/Humans/Group02/Male_05.mdl",
	"models/Humans/Group02/male_06.mdl",
	"models/Humans/Group02/male_07.mdl",
	"models/Humans/Group02/male_08.mdl",
	"models/Humans/Group02/male_09.mdl",

	"models/Humans/Group01/Female_01.mdl",
	"models/Humans/Group01/Female_02.mdl",
	"models/Humans/Group01/Female_03.mdl",
	"models/Humans/Group01/Female_04.mdl",
	"models/Humans/Group01/Female_06.mdl",
	"models/Humans/Group01/Female_07.mdl",
	"models/Humans/Group02/Female_01.mdl",
	"models/Humans/Group02/Female_02.mdl",
	"models/Humans/Group02/Female_03.mdl",
	"models/Humans/Group02/Female_04.mdl",
	"models/Humans/Group02/Female_06.mdl",
	"models/Humans/Group02/Female_07.mdl",
}


-- OLM Stuff
-- Don't change this on the client
-- unless you have a GOOD REASON to do so
TS.MessageTypes =
{
	GOOC = {id = 0, tabs = {1, 2}, ShowName = true, NameColor = nil, TextColor = Color(200, 200, 200, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- //
	LOOC = {id = 1, tabs = {1, 3}, ShowName = true, NameColor = Color(138, 185, 209, 255), TextColor = Color(138, 185, 209, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- [[
	SAY = {id = 2, tabs = {1, 3}, ShowName = true, NameColor = Color(91, 166, 211, 255), TextColor = Color(91, 166, 221, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = true}, -- 
	WHISPER = {id = 3, tabs = {1, 3}, ShowName = true, NameColor = Color(91, 166, 211, 255), TextColor = Color(91, 166, 221, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = true}, -- /w
	YELL = {id = 4, tabs = {1, 3}, ShowName = true, NameColor = Color(91, 166, 211, 255), TextColor = Color(91, 166, 221, 255), font = "NewChatFont", hook = nil, ACL = false, AlLog = true, ICLog = true}, -- /y
	ICACTION = {id = 5, tabs = {1, 3}, ShowName = false, NameColor = Color(131, 206, 251, 255), TextColor = Color(131, 196, 251, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = true}, -- /it
	EMOTE = {id = 6, tabs = {1, 3}, ShowName = false, NameColor = Color(131, 206, 251, 255), TextColor = Color(131, 196, 251, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = true}, -- /me
	PRIVMSG = {id = 7, tabs = {1, 5}, ShowName = false, NameColor = Color(200, 200, 200, 255), TextColor = Color(160, 255, 160, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- /pm
	BLUEMSG = {id = 8, tabs = {1, 2}, ShowName = false, NameColor = Color(200, 200, 200, 255), TextColor = Color(200, 200, 200, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- admin cmds -- why is this called blue?
	RADIO = {id = 9, tabs = {6}, ShowName = true, NameColor = Color( 72, 118, 255, 255 ), TextColor = Color( 72, 118, 255, 255 ), font = "NewChatFont", hook = nil, ACL = true, AllLog = true, ICLog = false}, -- radio. wrgs
	RADIOYELL = {id = 10, tabs = {6}, ShowName = true, NameColor = Color( 72, 118, 255, 255 ), TextColor = Color( 72, 118, 255, 255 ), font = "NewChatFont", hook = nil, ACL = true, AllLog = true, ICLog = true}, -- /ry
	RADIOWHISPER = {id = 11, tabs = {6}, ShowName = true, NameColor = Color( 72, 118, 255, 255 ), TextColor = Color( 72, 118, 255, 255 ), font = "NewChatFont", hook = nil, ACL = true, AllLog = true, ICLog = true}, -- /rw
	ADMIN = {id = 12, tabs = {1, 4}, ShowName = true, NameColor = Color(255, 107, 218, 255), TextColor = Color(255, 156, 230, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- !a
	CONSOLE = {id = 13, tabs = {1, 4}, ShowName = false, NameColor = Color(232, 20, 225, 255), TextColor = Color(200, 200, 200, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- csay
	MISC = {id = 14, tabs = {1}, ShowName = false, NameColor = Color(230, 20, 225, 255), TextColor = Color(255, 255, 149, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- umsg
	ADMINYELL = {id = 15, tabs = {1, 2}, ShowName = true, NameColor = Color(255, 255, 255, 255), TextColor = Color(232, 20, 20, 255), font = "GiantChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- rpa_yell
	NORMALMSG = {id = 16, tabs = {1, 3}, ShowName = false, NameColor = Color(111, 186, 241, 255), TextColor = Color(111, 186, 241, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- umsg
	DISPATCH = {id = 17, tabs = {1, 3}, ShowName = false, NameColor = Color(111, 186, 241, 255), TextColor = Color(111, 186, 241, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = true}, -- /dis
	BROADCAST = {id = 18, tabs = {1, 3}, ShowName = false, NameColor = Color(111, 186, 241, 255), TextColor = Color(111, 186, 241, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = true}, -- /br
	ADVERTISMENT = {id = 19, tabs = {1, 3}, ShowName = false, NameColor = Color(111, 186, 241, 255), TextColor = Color(111, 186, 241, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = true}, -- /adv
	EVENT = {id = 20, tabs = {1, 3}, ShowName = false, NameColor = Color(0, 191, 255, 255), TextColor = Color(0, 191, 255, 255), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = true}, -- /ev
	RADIODISPATCH = {id = 21, tabs = {1, 3, 6}, ShowName = false, NameColor = Color( 72, 118, 255, 255 ), TextColor = Color( 72, 118, 255, 255 ), font = "NewChatFont", hook = nil, ACL = true, AllLog = true, ICLog = true}, -- /rdis
	KICK = {id = 22, tabs = {1}, ShowName = false, NameColor = Color( 232, 20, 225, 255 ), TextColor = Color( 255, 255, 149, 255 ), font = "NewChatFont", hook = nil, ACL = false, AllLog = true, ICLog = false}, -- !kick
}

-- lookup after ID
do
	local addtab = {}
	for k, v in pairs(TS.MessageTypes) do
		addtab[v.id] = v
	end

	for k, v in pairs(addtab) do
		TS.MessageTypes[k] = v -- any nicer way to do this?
	end
end

-- IMPORTANT LOL --
TS.PlayerStats = 
{

	"Strength", 
	"Speed",
	"Endurance",
	"Aim",

}

TS.Inventories = { }
TS.Inventories["Pockets"] = "clothes_citizen";
TS.Inventories["Rebel vest"] = "clothes_rebel";
TS.Inventories["Rebel medic vest"] = "clothes_rebelmedic";
TS.Inventories["Backpack"] = "backpack";

TS.SQLData = { }
TS.SQLData["group_hastt"] = 0;
TS.SQLData["group_max_balloons"] = 0;
TS.SQLData["group_max_dynamite"] = 0;
TS.SQLData["group_max_effects"] = 0;
TS.SQLData["group_max_hoverballs"] = 0;
TS.SQLData["group_max_lamps"] = 0;
TS.SQLData["group_max_npcs"] = 0;
TS.SQLData["group_max_props"] = 0;
TS.SQLData["group_max_ragdolls"] = 0;
TS.SQLData["group_max_thrusters"] = 0;
TS.SQLData["group_max_vehicles"] = 0;
TS.SQLData["group_max_wheels"] = 0;
TS.SQLData["group_max_turrets"] = 0;
TS.SQLData["group_max_sents"] = 0;
TS.SQLData["group_max_spawners"] = 0;

--Get elapsed time in hours, minutes, and seconds
function GetHMS()

	local s = CurTime(); --How many total seconds do we have
	local totalm = math.floor( s / 60 ); --How many total minutes do we have
	local h = math.floor( totalm / 60 ); --How many total hours do we have
	
	local m = totalm - h * 60; --Minutes left
	s = s - totalm * 60; --Seconds left
	
	return h, m, math.floor( s );

end


function FormatLine( str, font, size, indent )

	if( not str ) then return; end

	local start = 1;
	local c = 1;
	
	surface.SetFont( font );
	
	local endstr = "";
	local n = 0;
	local lastspace = 0;
	local lastspacemade = 0;
	
	while( string.len( str ) > c ) do
	
		local sub = string.sub( str, start, c );
	
		if( string.sub( str, c, c ) == " " ) then
			lastspace = c;
		end

		if( surface.GetTextSize( sub ) >= size and lastspace ~= lastspacemade ) then
			
			local sub2;
			
			if( lastspace == 0 ) then
				lastspace = c;
				lastspacemade = c;
			end
			
			if( lastspace > 1 ) then
				sub2 = string.sub( str, start, lastspace - 1 );
				c = lastspace;
			else
				sub2 = string.sub( str, start, c );
			end
			
			endstr = endstr .. sub2 .. "\n";
			
			if indent then
				endstr = endstr .. indent
			end
			
			lastspace = c + 1;
			lastspacemade = lastspace;
			
			start = c + 1;
			n = n + 1;
		
		end
	
		c = c + 1;
	
	end
	
	if( start < string.len( str ) ) then
	
		endstr = endstr .. string.sub( str, start );
	
	end
	
	return endstr, n;

end