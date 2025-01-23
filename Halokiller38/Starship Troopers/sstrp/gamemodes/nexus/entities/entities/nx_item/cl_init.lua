--[[
Name: "cl_init.lua".
Product: "Nexus".
--]]

include("sh_init.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = nexus.schema.GetColor("target_id");
	local colorWhite = nexus.schema.GetColor("white");
	local index = self:GetSharedVar("sh_Index");
	
	if (index != 0) then
		local itemTable = nexus.item.Get(index);
		
		if (itemTable) then
			local color = itemTable.color or colorTargetID;
			
			if (itemTable.OnHUDPaintTargetID and itemTable:OnHUDPaintTargetID(self, x, y, alpha) == false) then
				return;
			end;
			
			y = NEXUS:DrawInfo(itemTable.name, x, y, color, alpha);
			
			if (itemTable.weightText) then
				y = NEXUS:DrawInfo(itemTable.weightText, x, y, colorWhite, alpha);
			else
				y = NEXUS:DrawInfo(itemTable.weight.."kg", x, y, colorWhite, alpha);
			end;
		end;
	end;
end;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
end;

-- Called each frame.
function ENT:Think()
	local itemTable = self.item;
	
	if (itemTable) then
		if (itemTable.OnEntityThink) then
			local nextThink = itemTable:OnEntityThink(self);
			
			if (type(nextThink) == "number") then
				self:NextThink(CurTime() + nextThink);
			end;
		end;
		
		nexus.mount.Call("NexusItemEntityThink", itemTable, self);
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	local drawModel = true;
	local index = self:GetSharedVar("sh_Index");
	
	if (index != 0) then
		local itemTable = nexus.item.Get(index);
		
		if (itemTable) then
			if (itemTable.OnDrawModel and itemTable:OnDrawModel(self) == false) then
				drawModel = false;
			end;
			
			if (nexus.mount.Call("NexusItemEntityDraw", itemTable, self) == false) then
				drawModel = false;
			end;
		end;
	end;
	
	if (drawModel) then
		self:DrawModel();
	end;
end;