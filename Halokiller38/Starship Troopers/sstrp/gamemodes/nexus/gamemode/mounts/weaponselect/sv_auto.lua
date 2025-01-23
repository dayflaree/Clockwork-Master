--[[
Name: "sv_auto.lua".
Product: "Nexus".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

-- Whether or not doors are hidden by default.
nexus.config.Add("weapon_selection_multi", false);

NEXUS:HookDataStream("SelectWeapon", function(player, data)
	if (type(data) == "string") then
		if ( player:HasWeapon(data) ) then
			player:SelectWeapon(data);
		end;
	end;
end);