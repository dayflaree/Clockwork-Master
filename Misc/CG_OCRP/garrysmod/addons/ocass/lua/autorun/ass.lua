/*
local PMeta = FindMetaTable('Player');
local OldSteamID = PMeta.SteamID;

function PMeta:SteamID ( )
	return string.gsub(SID, "STEAM_1", "STEAM_0");
end
*/

if SERVER then
	include("ass_server.lua")
elseif CLIENT then
	include("ass_client.lua")
end

