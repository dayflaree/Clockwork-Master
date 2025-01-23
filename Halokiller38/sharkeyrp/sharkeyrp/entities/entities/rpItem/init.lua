AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua")

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
	self:NextThink(CurTime() + 3); //Make it not lag if theres tons of em
end;

function ENT:GetData()
	return RP.item:Get(self.itemID);
end;

function ENT:SetItemID(itemID)
	if (RP.item:Get(itemID)) then
		self.itemID = itemID;
		local itemTable = RP.item:Get(itemID);
		self:SetModel(itemTable.model);
		self:SetDTInt("itemID", tonumber(itemID));
	end;
end;

function ENT:Use(player, caller)
	RP.inventory:PickupItem(player, self, self.itemID);
end;