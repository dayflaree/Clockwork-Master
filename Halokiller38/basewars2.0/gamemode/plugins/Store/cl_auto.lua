--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

function PLUGIN:BunkMenu()
	return;
end;

spawnmenu.AddCreationTab("Entities", PLUGIN.BunkMenu, "", 50)
spawnmenu.AddCreationTab("Vehicles", PLUGIN.BunkMenu, "", 50)
spawnmenu.AddCreationTab("NPCs", PLUGIN.BunkMenu, "", 50)
spawnmenu.AddCreationTab("Weapons", PLUGIN.BunkMenu, "", 50)