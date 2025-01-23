--[[
	Free Clockwork!
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetNotSolid(true);
	self:DrawShadow(false);
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- A function to get whether the entity should exist.
function ENT:GetShouldExist(player)
	local itemTable = self:GetItemTable();
	
	if (itemTable) then
		if (itemTable.GetAttachmentExists) then
			return itemTable:GetAttachmentExists(player, self);
		elseif (Clockwork.item:IsWeapon(itemTable)) then
			if (player:IsRagdolled()) then
				return player:RagdollHasWeapon(itemTable("weaponClass"));
			else
				return player:HasWeapon(itemTable("weaponClass"));
			end;
		else
			return true;
		end;
	end;
end;

-- A function to get whether the entity is visible.
function ENT:GetIsVisible(player)
	local itemTable = self:GetItemTable();
	
	if (itemTable) then
		if (itemTable.GetAttachmentVisible) then
			return itemTable:GetAttachmentVisible(player, self);
		elseif (Clockwork.item:IsWeapon(itemTable)) then
			return Clockwork.player:GetWeaponClass(player) != itemTable("weaponClass");
		else
			return true;
		end;
	end;
end;

-- A function to set the entity's item.
function ENT:SetItemTable(itemTable)
	self.cwItemTable = itemTable;
	self:SetDTInt("Index", itemTable("index"));
end;

-- Called each frame.
function ENT:Think()
	local player = self:GetPlayer();
	
	if (IsValid(player) and self:GetShouldExist(player)) then
		local pr, pg, pb, pa = player:GetColor();
		local er, eg, eb, ea = self:GetColor();
		
		if (!self:GetIsVisible(player)) then
			self:SetColor(255, 255, 255, 0);
			self:SetNoDraw(true);
		else
			self:SetColor(er, eg, eb, pa);
			self:SetNoDraw(false);
		end;
		
		self:SetMaterial(player:GetMaterial());
	else
		self:Remove();
	end;
end;