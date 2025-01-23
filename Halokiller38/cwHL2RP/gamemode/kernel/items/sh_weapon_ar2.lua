--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("custom_weapon");
ITEM.name = "ID Locked AR2";
ITEM.cost = 0;
ITEM.model = "models/Weapons/w_IRifle.mdl";
ITEM.weight = 2.5;
ITEM.factions = {FACTION_OTA};
ITEM.uniqueID = "weapon_ar2";
ITEM.weaponClass = "weapon_ar2";
ITEM.business = true;
ITEM.batch = 1;
ITEM.description = "A big laser gun!";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-2, 5, 4);

function ITEM:OnUse(player, itemEntity)
	if (!Clockwork.schema:PlayerIsCombine(player)) then
		Clockwork.player:Notify(player, "The weapon can only be used by the MPF, it has a lock on it that must be activated by some type of signal!");
		return false;
	end;
	
	local weaponClass = self("weaponClass");
	
	if (!player:HasWeapon(weaponClass)) then
		player:Give(weaponClass, self);
		
		local weapon = player:GetWeapon(weaponClass);
		
		if (IsValid(weapon)) then
			Clockwork.player:StripDefaultAmmo(
				player, weapon, self
			);
		end;
		
		local clipOne = self:GetData("ClipOne");
		local clipTwo = self:GetData("ClipTwo");
		
		if (clipOne > 0) then
			weapon:SetClip1(clipOne);
			self:SetData("ClipOne", 0);
		end;
		
		if (clipTwo > 0) then
			weapon:SetClip2(clipTwo);
			self:SetData("ClipTwo", 0);
		end;
		
		if (self.OnEquip) then
			self:OnEquip(player);
		end;
	else
		local weapon = player:GetWeapon(weaponClass);
		
		if (IsValid(weapon) and self.OnAlreadyHas) then
			if (Clockwork.item:GetByWeapon(weapon) == self) then
				self:OnAlreadyHas(player);
			end;
		end;
		
		return false;
	end;
end;

Clockwork.item:Register(ITEM);