--[[
		uBer
File: cl_hud.lua
--]]

--[[A function to set the default skin.]]--
function lib_hud_Skin(name,gamemode)
	local baseDirectory = "skins/";
	//if(!file.Find("../../gamemodes/"..gamemode.."/gamemode/skins/"..name..".lua")) then return end;
	Msg("uBer - Skins - Including: "..baseDirectory..name..".lua\n");
	if SERVER then
		include(baseDirectory..name..".lua");
	end
	if CLIENT then
		AddCSLuaFile(baseDirectory..name..".lua");
		
	end;
end;