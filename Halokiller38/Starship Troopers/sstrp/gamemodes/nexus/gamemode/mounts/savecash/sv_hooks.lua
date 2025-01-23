--[[
Name: "sv_hooks.lua".
Product: "Nexus".
--]]

local MOUNT = MOUNT;

-- Called when Nexus has loaded all of the entities.
function MOUNT:NexusInitPostEntity()
	if ( nexus.config.Get("cash_enabled"):Get() ) then
		self:LoadCash();
	end;
end;

-- Called just after data should be saved.
function MOUNT:PostSaveData()
	self:SaveCash();
end;