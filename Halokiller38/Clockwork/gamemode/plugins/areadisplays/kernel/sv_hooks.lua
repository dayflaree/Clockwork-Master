--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity() self:LoadAreaDisplays(); end;

-- Called when a player's data stream info should be sent.
function PLUGIN:PlayerSendDataStreamInfo(player)
	Clockwork:StartDataStream(player, "AreaDisplays", self.areaDisplays);
end;