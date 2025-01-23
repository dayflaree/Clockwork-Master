--[[
Name: "sv_auto.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

-- A function to get whether a player has a flashlight.
function MOUNT:PlayerHasFlashlight(player)
	local weapon = player:GetActiveWeapon();
	
	if ( IsValid(weapon) ) then
		local itemTable = nexus.item.GetWeapon(weapon);
		
		if ( weapon:GetClass() == "nx_flashlight" or (itemTable and itemTable.hasFlashlight) ) then
			return true;
		end;
	end;
end;