--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadParentData();
	self:LoadDoorData();
end;