--[[
Name: "cl_auto.lua".
Product: "Kyron".
--]]

RESISTANCE:IncludePrefixed("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = resistance.module.GetColor("target_id");
	local colorWhite = resistance.module.GetColor("white");
	local index = self:GetSharedVar("sh_Index");
	
	if (index != 0) then
		local itemTable = resistance.item.Get(index);
		
		if (itemTable) then
			y = RESISTANCE:DrawInfo(itemTable.name, x, y, itemTable.color or colorTargetID, alpha);
			
			if (itemTable.weightText) then
				y = RESISTANCE:DrawInfo(itemTable.weightText, x, y, colorWhite, alpha);
			else
				y = RESISTANCE:DrawInfo(itemTable.weight.."kg", x, y, colorWhite, alpha);
			end;
		end;
	end;
end;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;