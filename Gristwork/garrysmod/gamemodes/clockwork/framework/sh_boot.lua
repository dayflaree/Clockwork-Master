--[[ 
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local AddCSLuaFile = AddCSLuaFile;
local IsValid = IsValid;
local pairs = pairs;
local pcall = pcall;
local string = string;
local table = table;
local game = game;

--[[
	Past Contributors:
	Impulse (impulsh@gmail.com)
	Alex (gristhavoc@gmail.com)
--]]

if (!Clockwork) then
	Clockwork = GM;
else
	CurrentGM = Clockwork;
	table.Merge(CurrentGM, GM);
	Clockwork = nil;
	
	Clockwork = GM;
	table.Merge(Clockwork, CurrentGM);
	CurrentGM = nil;
end;

Clockwork.Name = "Clockwork";
Clockwork.Email = "gristhavoc@gmail.com";
Clockwork.Author = "Mr. Brightside";
Clockwork.Website = "http://alexgrist.com";
Clockwork.KernelVersion = "1.0";
Clockwork.SchemaFolder = Clockwork.SchemaFolder or GM.Folder;
Clockwork.ClockworkFolder = Clockwork.ClockworkFolder or GM.Folder;

--[[
	Do not edit this function. Editing this function will cause
	the schema to not function, and CloudAuthX will not
	auth you.
--]]
function Clockwork:GetGameDescription()
	local schemaName = self.kernel:GetSchemaGamemodeName();
	return "Insert Gamemode Name Here!";
end;

AddCSLuaFile("cl_kernel.lua");
AddCSLuaFile("sh_kernel.lua");
AddCSLuaFile("sh_enum.lua");
AddCSLuaFile("sh_boot.lua");
include("sh_enum.lua");
include("sh_kernel.lua");

if (CLIENT) then
	if (CW_SCRIPT_SHARED) then
		CW_SCRIPT_SHARED = Clockwork.kernel:Deserialize(CW_SCRIPT_SHARED);
	else
		CW_SCRIPT_SHARED = {};
	end;
end;

if (CW_SCRIPT_SHARED.schemaFolder) then
	Clockwork.SchemaFolder = CW_SCRIPT_SHARED.schemaFolder;
end;

if (!game.GetWorld) then
	game.GetWorld = function() return Entity(0); end;
end;

--[[ These are aliases to avoid variable name conflicts. --]]
cwPlayer, cwTeam, cwFile = player, team, file;
_player, _team, _file = player, team, file;

--[[ These are libraries that we want to load before any others. --]]
Clockwork.kernel:IncludePrefixed("libraries/sv_file.lua");
Clockwork.kernel:IncludeDirectory("libraries/", true);
Clockwork.kernel:IncludeDirectory("directory/", true);
Clockwork.kernel:IncludeDirectory("translations/", true);
Clockwork.kernel:IncludeDirectory("config/", true);
Clockwork.kernel:IncludePlugins("plugins/", true);
Clockwork.kernel:IncludeDirectory("system/", true);
Clockwork.kernel:IncludeDirectory("items/", true);
Clockwork.kernel:IncludeDirectory("derma/", true);

--[[ The following code is loaded by CloudAuthX. --]]
if (SERVER) then include("sv_cloudax.lua"); end;

--[[ The following code is loaded over-the-Cloud. --]]
if (SERVER and Clockwork.LoadPreSchemaExternals) then
	Clockwork:LoadPreSchemaExternals();
end;

--[[ Load the schema and let any plugins know about it. --]]
Clockwork.kernel:IncludeSchema();
Clockwork.plugin:Call("ClockworkSchemaLoaded");

--[[ The following code is loaded over-the-Cloud. --]]
if (SERVER and Clockwork.LoadPostSchemaExternals) then
	Clockwork:LoadPostSchemaExternals();
end;

if (CLIENT) then
	Clockwork.plugin:Call("ClockworkLoadShared", CW_SCRIPT_SHARED);
end;

Clockwork.kernel:IncludeDirectory("commands/", true);

-- Called when the Clockwork shared variables are added.
function Clockwork:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("InvWeight", true);
	playerVars:Number("MaxHP", true);
	playerVars:Number("MaxAP", true);
	playerVars:Number("IsDrunk", true);
	playerVars:Number("Wages", true);
	playerVars:Number("Cash", true);
	playerVars:Number("ForceAnim");
	playerVars:Number("IsRagdoll");
	playerVars:Bool("TargetKnows", true);
	playerVars:Bool("FallenOver", true);
	playerVars:Bool("CharBanned", true);
	playerVars:String("Clothes", true);
	playerVars:String("Model", true);
	globalVars:String("NoMySQL");
	globalVars:String("Date");
	globalVars:Number("Minute");
	globalVars:Number("Hour");
	globalVars:Number("Day");
end;

Clockwork.plugin:Call("ClockworkAddSharedVars",
	Clockwork.kernel:GetSharedVars():Global(true),
	Clockwork.kernel:GetSharedVars():Player(true)
);

Clockwork.plugin:IncludeEffects("clockwork/framework");
Clockwork.plugin:IncludeWeapons("clockwork/framework");
Clockwork.plugin:IncludeEntities("clockwork/framework");

if (SERVER) then
	Clockwork.plugin:Call("ClockworkSaveShared", CW_SCRIPT_SHARED);

	local scriptShared = "CW_SCRIPT_SHARED = [["..Clockwork.kernel:Serialize(CW_SCRIPT_SHARED).."]];";
	Clockwork.file:Write("lua/clockwork.lua", scriptShared);
	
	AddCSLuaFile("clockwork.lua");
end;