--[[
Name: "sv_auto.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

BLUEPRINT:IncludePrefixed("sh_auto.lua");

-- A function to get whether a player has a flashlight.
function PLUGIN:PlayerHasFlashlight(player)
	local weapon = player:GetActiveWeapon();
	
	if ( IsValid(weapon) ) then
		local itemTable = blueprint.item.GetWeapon(weapon);
		
		if ( weapon:GetClass() == "bp_flashlight" or (itemTable and itemTable.hasFlashlight) ) then
			return true;
		end;
	end;
end;