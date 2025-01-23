--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadStaticProps();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveStaticProps();
end;