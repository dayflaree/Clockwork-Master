--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	if (Clockwork.config:Get("cash_enabled"):Get()) then
		self:LoadCash();
	end;
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveCash();
end;