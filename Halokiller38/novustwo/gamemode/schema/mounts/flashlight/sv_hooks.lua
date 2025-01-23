--[[
Name: "sv_hooks.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

-- Called when a player switches their flashlight on or off.
function MOUNT:PlayerSwitchFlashlight(player, on)
	if ( on and !self:PlayerHasFlashlight(player) ) then
		return false;
	end;
end;

-- Called at an interval while a player is connected.
function MOUNT:PlayerThink(player, curTime, infoTable)
	if ( player:FlashlightIsOn() ) then
		if ( !self:PlayerHasFlashlight(player) ) then
			player:Flashlight(false);
		end;
	end;
end;