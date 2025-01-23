local playerMeta = FindMetaTable("Player");

/* Player Data Streams */

function playerMeta:StreamJoinData()

	local dataObj = {};
	dataObj.name = self.name;
	dataObj.cash = self.cash;
	dataObj.inventory = self.inventory;
	dataObj.data = self.data;
	
	RP:DataStream(self, "PlayerData", dataObj);
	
	local dataObj = {}
	for k, v in pairs(_player.GetAll()) do
		dataObj[v:SteamID()] = {
			name = v.name,
			job = v.job
		};
	end;
	
	RP:DataStream(self, "PlayerInfo", dataObj); //Stream that includes everyone
end;

function playerMeta:StreamPlayerData()
	local dataObj = {}
	
	dataObj[self:SteamID()] = {name = self.name};
	
	RP:DataStreamAll("PlayerInfo", dataObj); //Stream that includes only yourself
end;

function playerMeta:FilterInventory()
	for k, v in pairs(self.inventory) do
		if (!RP.item:Get(k)) then
			self.inventory[k] = nil;
		else
			for k, v in pairs(self.inventory) do	
				local count = 0;
				for itemID, itemData in pairs(v) do
					count = count + 1;
					RP.item:InsertID(itemID, k, itemData);
				end;
				if (count == 0) then
					self.inventory[k] = nil;
				end;
			end;
		end;
	end;
	self:SaveData();
end;

/* Data Handling */

function playerMeta:SetData(key, value)
	self.data[key] = value;
end;

function playerMeta:GetData(key)
	return self.data[key];
end;

/* Weapon and Ammo */

function playerMeta:GetAmmoData()
	if (!self.data["Ammo"]) then
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

/* Player Functions */

function playerMeta:Name()
	return self.name;
end;

function playerMeta:Nick()
	return self.name;
end;

function playerMeta:NetworkEquipment(action, itemID)	
	RP:DataStream(self, "NetworkEquipment", {action = action, itemID = itemID});
end;

function playerMeta:LoadItem(itemID)
	if (RP.item:Get(itemID)) then
		self:Give(RP.item:Get(itemID).weaponClass);
		timer.Simple(0, function(self, itemID)
			local weapon = self:GetWeapon(RP.item:Get(itemID).weaponClass);
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
			self:SetActiveWeapon(self:GetWeapon(RP.item:Get(itemID).weaponClass));
			if (weaponTable.Clip > 0) then
				self:RemoveAmmo(1, weaponTable.ammoClass);
			end;
		end, self, itemID);
	end;
end;

function playerMeta:UnloadItem(itemID)
	if (RP.item:Get(itemID) and RP.inventory:HasItem(self, RP.item:Get(itemID).uniqueID, itemID)) then
		if (RP.item:Get(itemID).weaponClass) then
			self:StripWeapon(RP.item:Get(itemID).weaponClass);
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
	local itemTable = RP.item:Get(itemID);
	if (itemTable) then
		if (RP.inventory:HasItem(self, itemTable.uniqueID, itemID)) then
			if (!self.primaryWeapon) then
				self.primaryWeapon = itemID;
				self:LoadItem(itemID);
			else
				self:UnloadItem(self.primaryWeapon);
				self.primaryWeapon = itemID;
				self:Give(RP.item:Get(itemID).weaponClass);
			end;
		else
			self:Notify("You do not own that item!");
		end;
	end;
end;

function playerMeta:LoadSecondary(itemID)
	local itemTable = RP.item:Get(itemID);
	if (itemTable) then
		if (RP.inventory:HasItem(self, itemTable.uniqueID, itemID)) then
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
	if (RP.inventory:HasItem(self, RP.item:Get(itemID).uniqueID, itemID)) then
		self:Give(RP.item:Get(itemID).weaponClass);
	else
		self:Notify("You do not own that item!");
	end;
end;

/* Player Data Management */

function playerMeta:LoadData()

	self.name = "Dave Puss";
	self.data = {created=false};
	self.inventory = {};
	self.cash = 0;

	RP.MySQL:Query("SELECT * FROM rp_players WHERE _SteamID = '"..self:SteamID().."'", function(result)	
		PrintTable(result);
		if (result[1]) then
			local playerDB = result[1];
			if (!self.steamName) then
				self.steamName = self:Nick();
			end;
			self.name = playerDB['_Name'];
			self.cash = playerDB['_Cash'];
			self.inventory = Json.Decode(playerDB['_Inventory']);
			self:FilterInventory();
			self.data = Json.Decode(playerDB['_Data']);
			print("Loaded Player: "..self.name);
			if (self.data['created'] == false) then
				self:CreateCharacter();
			end;
		else
			RP.MySQL:Query("INSERT INTO rp_players (_SteamID, _Name, _Cash, _Inventory, _Data) VALUES ('"..self:SteamID().."', '"..self.name.."', '"..self.cash.."', '"..Json.Encode(self.inventory).."', '"..Json.Encode(self.data).."')");
			self:CreateCharacter();
		end;
		timer.Simple(1, function(self)
			self:StreamJoinData()
			self:StreamPlayerData()
			RP:PlayerLoaded(self);
		end, self);
	end);
	
end;

function playerMeta:SaveData()
	RP.MySQL:Query("UPDATE rp_players SET _Cash = "..self.cash..", _Name = '"..self.name.."', _Inventory = '"..Json.Encode(self.inventory).."', _Data = '"..Json.Encode(self.data).."' WHERE _SteamID = '"..self:SteamID().."'");
end;

/* Character Creation */

function playerMeta:CreateCharacter()
	self.isCreating = true;
	RP:DataStream(self, "PlayerCreate", {});
end;

RP:DataHook("PlayerCreateInfo", function(player, data)
	local error = false
	if (player.isCreating) then	
		
		RP.MySQL:Query("SELECT * FROM rp_players WHERE _Name='"..data.name.."'", function(result)
			if (string.Trim(data.name) == "") then
				error = "You must enter a valid name!";
			else
				if (result[1]) then
					error = "A character already exists with that name!";
				end;
			end;
			
			if (error == false) then
				player.name = data.name;
				player.data['created'] = true;
				player:SaveData();
				player:StreamPlayerData();
				player.isCreating = false;
			else
				local dataObj = {}
				dataObj.fault = error;
				RP:DataStream(player, "PlayerCreate", dataObj);
			end;
		end);
		
	end;
end);