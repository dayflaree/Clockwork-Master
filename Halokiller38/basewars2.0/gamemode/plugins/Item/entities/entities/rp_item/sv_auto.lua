function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	
	local physObj = self:GetPhysicsObject();
	
	if (IsValid(physObj)) then
		physObj:Wake();
		physObj:EnableMotion(true);
	end;
end;

function ENT:Think()
	self:NextThink(CurTime() + 3);
end;

function ENT:GetData()
	return RP.Item:Get(self.ItemID);
end;

function ENT:SetItemID(itemID)
	if (RP.Item:Get(itemID)) then
		self.ItemID = itemID;
		local itemTable = RP.Item:Get(itemID);
		self:SetModel(itemTable.model);
		self:SetDTInt("itemID", tonumber(itemID));
	end;
end;

function ENT:Use(player, caller)
	local itemTable = RP.Item:Get(self.ItemID);
	
	local pickupCallback = function(ply, entity)
		RP.Inventory:PickupItem(ply, self, self.ItemID);
	end;
	local useCallback = function(ply, entity)
		RP.Inventory:PickupItem(ply, self, self.ItemID);
		itemTable:OnUse(ply);
	end;
	
	local options = {
		{text = "Take", callback = pickupCallback},
		{text = "Use", callback = useCallback},
	};
	
	RP.popup:Create(player, self.Entity, itemTable.name, options, 70);
end;
