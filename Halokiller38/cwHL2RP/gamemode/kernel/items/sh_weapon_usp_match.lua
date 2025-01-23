--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("custom_weapon");
ITEM.batch = 1;
ITEM.name = "ID Locked USP-M";
ITEM.cost = 0;
ITEM.model = "models/weapons/w_pistol.mdl";
ITEM.weight = 1.5;
ITEM.business = true;
ITEM.batch = 1;
ITEM.classes = {CLASS_MPF_EPU, CLASS_MPF_OFC, CLASS_MPF_DVL, CLASS_MPF_SEC};
ITEM.weaponClass = "rcs_uspmatch";
ITEM.description = "A small, compact and accurate pistol.\nThis firearm utilises 9x19mm ammunition.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(5, -4, -3);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(0, 0, 90);
ITEM.attachmentOffsetVector = Vector(0, 4, -8);

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