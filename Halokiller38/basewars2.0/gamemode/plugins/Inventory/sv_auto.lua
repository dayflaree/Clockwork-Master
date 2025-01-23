--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

function PLUGIN:PlayerDataLoaded(player)
	player:SetAmmoTable(player:GetAmmoData());
end;

/* Weapon and Ammo */

local playerMeta = FindMetaTable("Player");

function playerMeta:GetAmmoData()
	if (!self.rpData["Ammo"]) then
		self:SetAmmoData();
	end;
	return self:GetData("Ammo");
end;

function playerMeta:SetAmmoData()
	self:SetData("Ammo", self:GetAmmoTable());
end;

function playerMeta:SetAmmoTable(aTable)
	self:RemoveAllAmmo();
	for k, v in pairs(aTable) do
		self:GiveAmmo(v, k);
	end;
end;

function playerMeta:GetAmmoTable()
	
	local ammo = {
		["sniperpenetratedround"] = self:GetAmmoCount("sniperpenetratedround"),
		["striderminigun"] = self:GetAmmoCount("striderminigun"),
		["helicoptergun"] = self:GetAmmoCount("helicoptergun"),
		["combinecannon"] = self:GetAmmoCount("combinecannon"),
		["smg1_grenade"] = self:GetAmmoCount("smg1_grenade"),
		["gaussenergy"] = self:GetAmmoCount("gaussenergy"),
		["sniperround"] = self:GetAmmoCount("sniperround"),
		["airboatgun"] = self:GetAmmoCount("airboatgun"),
		["ar2altfire"] = self:GetAmmoCount("ar2altfire"),
		["rpg_round"] = self:GetAmmoCount("rpg_round"),
		["xbowbolt"] = self:GetAmmoCount("xbowbolt"),
		["buckshot"] = self:GetAmmoCount("buckshot"),
		["alyxgun"] = self:GetAmmoCount("alyxgun"),
		["grenade"] = self:GetAmmoCount("grenade"),
		["thumper"] = self:GetAmmoCount("thumper"),
		["gravity"] = self:GetAmmoCount("gravity"),
		["battery"] = self:GetAmmoCount("battery"),
		["pistol"] = self:GetAmmoCount("pistol"),
		["slam"] = self:GetAmmoCount("slam"),
		["smg1"] = self:GetAmmoCount("smg1"),
		["357"] = self:GetAmmoCount("357"),
		["ar2"] = self:GetAmmoCount("ar2")
	};
	
	for k, v in pairs(ammo) do
		if (ammo[k] <= 0) then
			ammo[k] = nil;
		end;
	end;
	
	return ammo;
end;

function playerMeta:NetworkEquipment(action, itemID)	
	RP:DataStream(self, "NetworkEquipment", {action = action, itemID = itemID});
end;

function playerMeta:LoadItem(itemID)
	if (RP.Item:Get(itemID)) then
		local weaponClass = self:GetActiveWeapon():GetClass();
		self:Give(RP.Item:Get(itemID).weaponClass);
		self:SelectWeapon(weaponClass);
		timer.Simple(0, function(self, itemID)
			local weapon = self:GetWeapon(RP.Item:Get(itemID).weaponClass);
			weapon.Primary.DefaultClip = 0;
			weapon:SetClip1(0);
			weapon:SetClip2(0);
			local weaponTable = self:GetWeaponTable(weapon.Pistol);
			weapon:SetNWString("ItemID", weaponTable.itemID);
			if (weaponTable) then
				if (weaponTable.Clip > 0) then
					self:GiveAmmo(1, weaponTable.ammoClass);
					weapon:SetClip1(weaponTable.Clip);
				end;
				weapon.Primary.ClipSize = weaponTable.ClipMax;
				if (weaponTable.Damage) then
					weapon.Primary.Damage = weaponTable.Damage;
				end;
				if (weaponTable.Spread) then
					weapon.Primary.Cone = weaponTable.Spread;
				end;
				if (weaponTable.Delay) then
					weapon.Primary.Delay = weaponTable.Delay;
				end;
				if (weaponTable.NumShots) then
					weapon.Primary.NumShots = weaponTable.NumShots;
				end;
				if (weaponTable.Recoil) then
					weapon.Primary.Recoil = weaponTable.Recoil;
				end;
				if (weaponTable.FireSound) then
					weapon.Primary.Sound = weaponTable.FireSound;
				end;
				if (weaponTable.ShootEffect) then
					weapon.Tracer = weaponTable.ShootEffect;
				end;
				if (weaponTable.ScopeZooms) then
					weapon.ScopeZooms = weaponTable.ScopeZooms;
				end;
				if (type(weaponTable.BurstInfo) == "table") then
					weapon.Burst = true;
					weapon.BurstShots = weaponTable.BurstInfo.Shots;
					weapon.BurstDelay = weaponTable.BurstInfo.Delay;
				end;
				self:NetworkEquipment("equip", itemID);
			end;
			self:SetActiveWeapon(self:GetWeapon(RP.Item:Get(itemID).weaponClass));
			if (weaponTable.Clip > 0) then
				self:RemoveAmmo(1, weaponTable.ammoClass);
			end;
		end, self, itemID);
	end;
end;

function playerMeta:UnloadItem(itemID)
	if (RP.Item:Get(itemID) and RP.Inventory:HasItem(self, RP.Item:Get(itemID).uniqueID, itemID)) then
		if (RP.Item:Get(itemID).weaponClass) then
			self:StripWeapon(RP.Item:Get(itemID).weaponClass);
			self:NetworkEquipment("unequip", itemID);
			self:SetActiveWeapon(self:GetWeapon("weapon_physcannon"));
			if (self.primaryWeapon == itemID) then
				self.primaryWeapon = false;
			elseif (self.secondaryWeapon == itemID) then
				self.secondaryWeapon = false;
			end;
		end;
	end;
end;

function playerMeta:LoadPrimary(itemID)
	local itemTable = RP.Item:Get(itemID);
	if (itemTable) then
		if (RP.Inventory:HasItem(self, itemTable.uniqueID, itemID)) then
			if (!self.primaryWeapon) then
				self.primaryWeapon = itemID;
				self:LoadItem(itemID);
			else
				self:UnloadItem(self.primaryWeapon);
				self.primaryWeapon = itemID;
				local weaponClass = self:GetActiveWeapon():GetClass();
				self:Give(RP.Item:Get(itemID).weaponClass);
				self:SelectWeapon(weaponClass);
			end;
		else
			self:Notify("You do not own that item!");
		end;
	end;
end;

function playerMeta:LoadSecondary(itemID)
	local itemTable = RP.Item:Get(itemID);
	if (itemTable) then
		if (RP.Inventory:HasItem(self, itemTable.uniqueID, itemID)) then
			if (!self.secondaryWeapon) then
				self.secondaryWeapon = itemID;
				self:LoadItem(itemID);
			else
				self:UnloadItem(self.secondaryWeapon);
				self.secondaryWeapon = itemID;
				self:LoadItem(itemID);
			end;
		else
			self:Notify("You do not own that item!");
		end;
	end;
end;

function playerMeta:LoadEquipment(itemID)
	if (RP.Inventory:HasItem(self, RP.Item:Get(itemID).uniqueID, itemID)) then
		local weaponClass = self:GetActiveWeapon():GetClass();
		self:Give(RP.Item:Get(itemID).weaponClass);
		self:SelectWeapon(weaponClass);
	else
		self:Notify("You do not own that item!");
	end;
end;