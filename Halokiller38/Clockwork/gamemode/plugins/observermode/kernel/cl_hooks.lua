--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called to get whether the local player can see the admin ESP.
function PLUGIN:PlayerCanSeeAdminESP()
	if (!Clockwork.player:IsNoClipping(Clockwork.Client)) then
		return false;
	end;
end;

-- Called when a player attempts to NoClip.
function PLUGIN:PlayerNoClip(player)
	return false;
end;