--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Weapon Base";
ITEM.useText = "Equip";
ITEM.useSound = false;
ITEM.category = "Firearms";
ITEM.useInVehicle = false;

local defaultWeapons = {
	["weapon_357"] = {"357", nil, true},
	["weapon_ar2"] = {"ar2", "ar2altfire", 30},
	["weapon_rpg"] = {"rpg_round", nil, 3},
	["weapon_smg1"] = {"smg1", "smg1_grenade", true},
	["weapon_slam"] = {"slam", nil, 2},
	["weapon_frag"] = {"grenade", nil, 1},
	["weapon_pistol"] = {"pistol", nil, true},
	["weapon_shotgun"] = {"buckshot", nil, true},
	["weapon_crossbow"] = {"xbowbolt", nil, 4}
};

ITEM:AddData("ClipOne", 0, true);
ITEM:AddData("ClipTwo", 0, true);

-- Called whent he item entity's menu options are needed.
function ITEM:GetEntityMenuOptions(entity, options)
	if (self:HasSecondaryClip() or self:HasPrimaryClip()) then
		local informationColor = Clockwork.option:GetColor("information");
		local toolTip = Clockwork:AddMarkupLine("", "Salvage any ammo from this weapon.", informationColor);
		local clipOne = self:GetData("ClipOne");
		local clipTwo = self:GetData("ClipTwo");
		
		if (clipOne > 0 or clipTwo > 0) then
			if (clipOne > 0) then
				toolTip = Clockwork:AddMarkupLine(toolTip, "Primary: "..clipOne);
			end;
			
			if (clipTwo > 0) then
				toolTip = Clockwork:AddMarkupLine(toolTip, "Secondary: "..clipTwo);
			end;
			
			options["Ammo"] = {
				isArgTable = true,
				arguments = "cwItemAmmo",
				toolTip = toolTip
			};
		end;
	end;
end;

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	local weaponClass = self("weaponClass");
	
	if (SERVER) then
		local weapon = player:GetWeapon(weaponClass);
		local itemTable = Clockwork.item:GetByWeapon(weapon);
		
		if (itemTable and itemTable:IsTheSameAs(self)) then
			return true;
		end;
	end;
	
	--[[
		Just returning true here because there isn't
		a GetWeapon function client-side. Yet...
	--]]
	if (CLIENT and bIsValidWeapon) then
		return true;
	end;
	
	return false;
end;

-- Called when a player attempts to holster the weapon.
function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	return true;
end;

-- Called when the unequip should be handled.
function ITEM:OnHandleUnequip(Callback)
	if (self.OnDrop) then
		local menu = DermaMenu();
			menu:AddOption("Holster", function()
				Callback();
			end);
			menu:AddOption("Drop", function()
				Callback("drop");
			end);
		menu:Open();
	else
		Callback();
	end;
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	local weapon = player:GetWeapon(self("weaponClass"));
	if (!IsValid(weapon)) then return; end;
	
	local itemTable = Clockwork.item:GetByWeapon(weapon);
	
	if (itemTable:IsTheSameAs(self)) then
		local class = weapon:GetClass();
		
		if (extraData != "drop") then
			if (Clockwork.plugin:Call("PlayerCanHolsterWeapon", player, self, weapon)) then
				if (player:GiveItem(self)) then
					Clockwork.plugin:Call("PlayerHolsterWeapon", player, self, weapon);
					player:StripWeapon(class);
					player:SelectWeapon("cw_hands");
				end;
			end;
		elseif (Clockwork.plugin:Call("PlayerCanDropWeapon", player, self, weapon)) then
			local trace = player:GetEyeTraceNoCursor();
			
			if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
				local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos);
				
				if (IsValid(entity)) then
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
					Clockwork.plugin:Call("PlayerDropWeapon", player, self, entity, weapon);
					
					player:TakeItem(self, true);
					player:StripWeapon(class);
					player:SelectWeapon("cw_hands");
				end;
			else
				Clockwork.player:Notify(player, "You cannot drop your weapon that far away!");
			end;
		end;
	end;
end;

-- A function to get whether the item has a secondary clip.
function ITEM:HasSecondaryClip()
	return !self("hasNoSecondaryClip");
end;

-- A function to get whether the item has a primary clip.
function ITEM:HasPrimaryClip()
	return !self("hasNoPrimaryClip");
end;

-- A function to get whether the item is a throwable weapon.
function ITEM:IsThrowableWeapon()
	return self("isThrowableWeapon");
end;

-- A function to get whether the item is a fake weapon.
function ITEM:IsFakeWeapon()
	return self("isFakeWeapon");
end;

-- A function to get whether the item is a melee weapon.
function ITEM:IsMeleeWeapon()
	return self("isMeleeWeapon");
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
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

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item should be setup.
function ITEM:OnSetup()
	if (!self("weaponClass")) then
		self:Override("weaponClass", self("uniqueID"));
	end;
	
	self:Override("weaponClass", string.lower(self("weaponClass")));
	
	timer.Simple(2, function()
		local weaponClass = self("weaponClass");
		local weaponTable = weapons.GetStored(weaponClass);
		
		if (weaponTable) then
			if (!self("primaryAmmoClass")) then
				if (weaponTable.Primary and weaponTable.Primary.Ammo) then
					self:Override("primaryAmmoClass", weaponTable.Primary.Ammo);
				end;
			end;
			
			if (!self("secondaryAmmoClass")) then
				if (weaponTable.Secondary and weaponTable.Secondary.Ammo) then
					self:Override("secondaryAmmoClass", weaponTable.Secondary.Ammo);
				end;
			end;
			
			if (!self("primaryDefaultAmmo")) then
				if (weaponTable.Primary and weaponTable.Primary.DefaultClip) then
					if (weaponTable.Primary.DefaultClip > 0) then
						if (weaponTable.Primary.ClipSize == -1) then
							self:Override("primaryDefaultAmmo", weaponTable.Primary.DefaultClip);
							self:Override("hasNoPrimaryClip", true);
						else
							self:Override("primaryDefaultAmmo", true);
						end;
					end;
				end;
			end;
			
			if (!self("secondaryDefaultAmmo")) then
				if (weaponTable.Secondary and weaponTable.Secondary.DefaultClip) then
					if (weaponTable.Secondary.DefaultClip > 0) then
						if (weaponTable.Secondary.ClipSize == -1) then
							self:Override("secondaryDefaultAmmo", weaponTable.Secondary.DefaultClip);
							self:Override("hasNoSecondaryClip", true);
						else
							self:Override("secondaryDefaultAmmo", true);
						end;
					end;
				end;
			end;
		elseif (defaultWeapons[weaponClass]) then
			if (!self("primaryAmmoClass")) then
				self:Override("primaryAmmoClass", defaultWeapons[weaponClass][1]);
			end;
			
			if (!self("secondaryAmmoClass")) then
				self:Override("secondaryAmmoClass", defaultWeapons[weaponClass][2]);
			end;
			
			if (!self("primaryDefaultAmmo")) then
				self:Override("primaryDefaultAmmo", defaultWeapons[weaponClass][3]);
			end;
			
			if (!self("secondaryDefaultAmmo")) then
				self:Override("secondaryDefaultAmmo", defaultWeapons[weaponClass][4]);
			end;
		end;
	end);
end;

-- Called when a player holsters the item.
function ITEM:OnHolster(player, bForced) end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then
			return;
		end;
		
		local clientSideInfo = "";
		local clipOne = self:GetData("ClipOne");
		local clipTwo = self:GetData("ClipTwo");
		
		if (clipOne > 0) then
			clientSideInfo = Clockwork:AddMarkupLine(clientSideInfo, "Clip One: "..clipOne);
		end;
		
		if (clipTwo > 0) then
			clientSideInfo = Clockwork:AddMarkupLine(clientSideInfo, "Clip Two: "..clipTwo);
		end;
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
end;

Clockwork.item:Register(ITEM);