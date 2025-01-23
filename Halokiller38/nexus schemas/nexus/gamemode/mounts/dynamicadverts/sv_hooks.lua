--[[
Name: "sv_hooks.lua".
Product: "Nexus".
--]]

local MOUNT = MOUNT;

-- Called when Nexus has loaded all of the entities.
function MOUNT:NexusInitPostEntity() self:LoadDynamicAdverts(); end;

-- Called when a player's data stream info should be sent.
function MOUNT:PlayerSendDataStreamInfo(player)
	NEXUS:StartDataStream(player, "DynamicAdverts", self.dynamicAdverts);
end;