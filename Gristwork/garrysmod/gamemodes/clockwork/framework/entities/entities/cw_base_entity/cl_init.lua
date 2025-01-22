
include("shared.lua")

-- Called when the entity should draw.
function ENT:Draw()
	if (Clockwork.Client:GetPos():Distance(self:GetPos()) > 1000) then 
		return;
	end;

	if (Clockwork.entity:HasFetchedItemData(self)) then
		local itemTable = self:GetItemTable();

		if (itemTable.OnDraw) then
			itemTable:OnDraw(self);
		end;
	end;

	self:DrawModel();
end;

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	if (Clockwork.entity:HasFetchedItemData(self)) then
		local colorTargetID = Clockwork.option:GetColor("target_id");
		local itemTable = Clockwork.entity:FetchItemTable(self);
		local color = itemTable("color") or colorTargetID;
		
		y = Clockwork.kernel:DrawInfo(itemTable("name"), x, y, color, alpha);
		
		if (itemTable and itemTable.OnHUDPaintTargetID) then
			itemTable:OnHUDPaintTargetID(self, x, y, alpha);
		end;
	end;
end;

-- Called each frame.
function ENT:Think()
	if (!Clockwork.entity:HasFetchedItemData(self)) then
		Clockwork.entity:FetchItemData(self);
		return;
	end;
	
	local itemTable = Clockwork.entity:FetchItemTable(self);
	
	if (itemTable and itemTable.OnEntityThink) then
		itemTable:OnEntityThink(self);
	end;
end;