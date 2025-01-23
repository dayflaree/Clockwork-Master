--[[
Name: "cl_init.lua".
Product: "Nexus".
--]]

include("sh_init.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
end;

-- Called when the entity should draw.
function ENT:Draw()
	if (nexus.mount.Call("NexusGeneratorEntityDraw", self) != false) then
		self:DrawModel();
	end;
end;