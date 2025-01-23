local playerMeta = FindMetaTable("Player");

RP:DataHook("PlayerData", function(data)
	RP.Client.cash = data.cash;
	RP.Client.inventory = data.inventory;
	RP.Client.data = data.data;
	RP.Client.job = "citizen";
end);

RP:DataHook("PlayerInfo", function(data)
	for k, v in pairs(data) do
		local player = RP.player:GetSteamID(k);
		player:SetRPName(v.name);
		if (v.job) then
			player.job = v.job;
		else
			player.job = "citizen";
		end;
	end;
end);

RP:DataHook("PlayerCreate", function(data)
	print("Making new Character");
	local prompt = "What is your name? (First and Last)";
	if (data.fault) then
		prompt = data.fault;
	end;
	
	Derma_StringRequest("Character Setup", prompt, "", function(nameText)
		local dataObj = {};
		dataObj.name = nameText;
		RP:DataStream("PlayerCreateInfo", dataObj);
	end);
end);

RP:DataHook("NetworkEquipment", function(data)
	RP.Client:HandleNetworkEquipment(data.action, data.itemID);
end);

function playerMeta:HandleNetworkEquipment(action, itemID)
	if (action == "equip") then
		local itemTable = RP.item:Get(itemID);
		if (itemTable) then
			if (itemTable.isPrimary) then
				self.primaryWeapon = itemID;
			elseif (itemTable.isSecondary) then
				self.secondaryWeapon = itemID;
			elseif (itemTable.equipment) then
				if (!self.loadedEquipment) then
					self.loadedEquipment = {};
				end;
				self.loadedEquipment[#self.loadedEquipment+1] = itemID;
			end;
			timer.Simple(1, function(self, itemTable, itemID)
				local weapon;
				for _, v in pairs(self:GetWeapons()) do
					print(v:GetPrintName());
					print(v:GetNWString("ItemID").." : "..itemID);
					if (v:GetNWString("ItemID") == itemID) then
						weapon = v;
					end;
				end;
				print("Got Weapon "..weapon:GetPrintName());
				if (itemTable.Spread) then
					weapon.Primary.Cone = itemTable.Spread;
				end;
				if (itemTable.Delay) then
					weapon.Primary.Delay = itemTable.Delay;
				end;
				if (itemTable.NumShots) then
					weapon.Primary.NumShots = itemTable.NumShots;
				end;
				if (itemTable.Recoil) then
					weapon.Primary.Recoil = itemTable.Recoil;
				end;
				if (itemTable.FireSound) then
					weapon.Primary.Sound = itemTable.FireSound;
				end;
				if (itemTable.ShootEffect) then
					weapon.Tracer = itemTable.ShootEffect;
				end;
				if (itemTable.ScopeZooms) then
					weapon.ScopeZooms = itemTable.ScopeZooms;
				end;
				if (type(itemTable.BurstInfo) == "table") then
					weapon.Burst = true;
					weapon.BurstShots = itemTable.BurstInfo.Shots;
					weapon.BurstDelay = itemTable.BurstInfo.Delay;
				end;
			end, self, itemTable, itemID);
		end;
	elseif (action == "unequip") then
		local itemTable = RP.item:Get(itemID);
		if (itemTable) then
			if (itemTable.isPrimary) then
				self.primaryWeapon = false;
			elseif (itemTable.isSecondary) then
				self.secondaryWeapon = false;
			elseif (itemTable.equipment) then
				if (!self.loadedEquipment) then
					self.loadedEquipment = {};
				end;
				for k, v in pairs(self.loadedEquipment) do
					if (v == itemID) then
						self.loadedEquipment[k] = nil;
					end;
				end;
			end;
		end;
	else
		self:Notify("Invalid HandleNetworkEquip Action '"..action.."'!");
	end;
end;

function playerMeta:SetRPName(name)
	if (!self.steamName) then
		self.steamName = self:Nick();
	end;
	self.name = name;
end;

function playerMeta:Name()
	return self.name;
end;