local PLUGIN = PLUGIN;

local playerMeta = FindMetaTable("Player");

RP:DataHook("NetworkEquipment", function(data)
	RP.Client:HandleNetworkEquipment(data.action, data.itemID);
end);

function playerMeta:HandleNetworkEquipment(action, itemID)
	if (action == "equip") then
		local itemTable = RP.Item:Get(itemID);
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
		local itemTable = RP.Item:Get(itemID);
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