--[[
Name: "sv_hooks.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

-- Called when a player switches their flashlight on or off.
function PLUGIN:PlayerSwitchFlashlight(player, on)
	if ( on and !self:PlayerHasFlashlight(player) ) then
		return false;
	end;
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	if ( player:FlashlightIsOn() ) then
		if ( !self:PlayerHasFlashlight(player) ) then
			player:Flashlight(false);
		end;
	end;
end;