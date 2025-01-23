--[[
Name: "sv_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

resistance.hint.AddHumanHint("Flashlight", "If it's dark outside and you can't see, invest in a flashlight.");

-- A function to get whether a player has a flashlight.
function PLUGIN:PlayerHasFlashlight(player)
	if ( MODULE:PlayerIsCombine(player) ) then
		return true;
	end;
	
	local weapon = player:GetActiveWeapon();
	
	if ( IsValid(weapon) ) then
		local itemTable = resistance.item.GetWeapon(weapon);
		
		if ( weapon:GetClass() == "roleplay_flashlight" or (itemTable and itemTable.hasFlashlight) ) then
			return true;
		end;
	end;
end;