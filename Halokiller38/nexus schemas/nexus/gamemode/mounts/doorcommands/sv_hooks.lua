--[[
Name: "sv_hooks.lua".
Product: "Nexus".
--]]

local MOUNT = MOUNT;

-- Called when Nexus has loaded all of the entities.
function MOUNT:NexusInitPostEntity()
	self:LoadParentData();
	self:LoadDoorData();
end;