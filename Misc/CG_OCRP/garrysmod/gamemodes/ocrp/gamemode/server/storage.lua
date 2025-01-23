function META:Inv_GiveItem(item,amount)
	if self.OCRPData == nil then return end
	if self.OCRPData["Inventory"] == nil then return end
	if self.OCRPData["Inventory"][item] == nil then self.OCRPData["Inventory"][item] = 0 end
	if amount == nil then
		amount = 1
	end
	self.OCRPData["Inventory"][item] = self.OCRPData["Inventory"][item] + amount
	if GAMEMODE.OCRP_Items[item].AmmoType != nil && self:IsPlayer() then
		self:GiveAmmo( amount, GAMEMODE.OCRP_Items[item].AmmoType,true )
	end
	self.OCRPData["Inventory"].WeightData.Cur = self.OCRPData["Inventory"].WeightData.Cur + GAMEMODE.OCRP_Items[item].Weight*amount
end

function META:HasItem(item,amount)
	if self.OCRPData == nil then return false end
	if self.OCRPData["Inventory"] == nil then return false end
	if amount == nil then amount = 1 end
	if self.OCRPData["Inventory"][item] == nil then return false end
	if self.OCRPData["Inventory"][item] >= amount then
		return true
	end
	return false
end

function META:HasRoom(item,amount)
	if self.OCRPData == nil then return false end
	if self.OCRPData["Inventory"] == nil then return false end
	if amount == nil then amount = 1 end
	if (self.OCRPData["Inventory"].WeightData.Cur + (GAMEMODE.OCRP_Items[item].Weight * amount)) <= self.OCRPData["Inventory"].WeightData.Max then
		return true
	end
	if self:IsPlayer() then
		self:Hint("You don't have enough room for that")
	end
	return false
end

function META:Inv_RemoveItem(item,amount)
	if self.OCRPData == nil then return end
	if self.OCRPData["Inventory"] == nil then return end
	if !self:HasItem(item) then return end
	if amount == nil then
		amount = 1
	end
	self.OCRPData["Inventory"][item] = self.OCRPData["Inventory"][item] - amount
	if GAMEMODE.OCRP_Items[item].AmmoType != nil && self:IsPlayer() then
		self:RemoveAmmo( amount, GAMEMODE.OCRP_Items[item].AmmoType,true )
	end	
	self.OCRPData["Inventory"].WeightData.Cur = self.OCRPData["Inventory"].WeightData.Cur - GAMEMODE.OCRP_Items[item].Weight*amount
	
end

function PMETA:WithdrawItem(item,Objectid)
	local Object = ents.GetByIndex(Objectid)
	if Object == self then return end
	if Object:GetClass() != "gov_resupply" then
		if self:HasRoom(item,1) && Object:HasItem(item) then
			if Object:GetClass() != "gov_resupply" then
				if Object:IsPlayer() then
					Object:RemoveItem(item)
				else
					Object:Inv_RemoveItem(item)
					self:UnStoreItem(item)
				end
			else
				Object:Inv_RemoveItem(item)
			end
			local empty = true
			for item,amount in pairs(Object.OCRPData["Inventory"]) do
				if item != "WeightData" then
					self:UpdateObjectItem(Object,item)
					empty = false
				end	
			end
			if empty then
				self:UpdateObject(Object)
			end
			self:GiveItem(item)
		elseif !Object:HasItem(item) && self:StorageHasItem(item) then
			self:UnStoreItem(item)
		end
	else
		if self:Team() == CLASS_CHIEF || self:Team() == CLASS_SWAT || self:Team() == CLASS_POLICE then
			if self:HasRoom(item,1) && Object:HasItem(item) then
				for _,data in pairs(GAMEMODE.Locker_Items) do
					if data.Item == item then
						if !self:HasItem(data.Item,GAMEMODE.Police_Maxes[data.Item]) then
							Object:Inv_RemoveItem(item)
							local empty = true
							for item,amount in pairs(Object.OCRPData["Inventory"]) do
								if item != "WeightData" then
									self:UpdateObjectItem(Object,item)
									empty = false
								end	
							end
							if empty then
								self:UpdateObject(Object)
							end
							self:GiveItem(item)
							break 
						else
							self:Hint("You have reached the limit for that item")
							break
						end
					end
				end
			end
		end
	end
end
concommand.Add("OCRP_WithdrawItem", function(ply, command, args) ply:WithdrawItem(tostring(args[1]),tonumber(args[2]))  end)

function PMETA:DepositItem(item,Objectid)
	local Object = ents.GetByIndex(Objectid)
	local player = player.GetByID(Object:GetNWInt("Owner")) 
	if Object:GetClass() != "gov_resupply" then
		if Object:HasRoom(item,1) && self:HasItem(item) then
			Object:Inv_GiveItem(item)
			if self != player && player:IsValid() then
				player:StoreItem(item)
			else
				self:StoreItem(item)
			end
			local empty = true
			for item,amount in pairs(Object.OCRPData["Inventory"]) do
				if item != "WeightData" then
					self:UpdateObjectItem(Object,item)
					empty = false
				end	
			end
			if empty then
				self:UpdateObject(Object)
			end
			self:RemoveItem(item)
		end
	else
		if Object:HasRoom(item,1) && self:HasItem(item) then
			for _,data in pairs(GAMEMODE.Locker_Items) do
				if data.Item == item then
					Object:Inv_GiveItem(item)
					local empty = true
					for item,amount in pairs(Object.OCRPData["Inventory"]) do
						if item != "WeightData" then
							self:UpdateObjectItem(Object,item)
							empty = false
						end	
					end
					if empty then
						self:UpdateObject(Object)
					end
					self:RemoveItem(item)
					break 
				end
			end
		end
	end
end
concommand.Add("OCRP_DepositItem", function(ply, command, args) ply:DepositItem(tostring(args[1]),tonumber(args[2])) end)

function PMETA:StoreItem(item,amount)
	if !self.Loaded then return end
	if self.OCRPData == nil then return end
	if item == "item_pot" then return end
	if self.OCRPData["Storage"] == nil then  self.OCRPData["Storage"] = {}  end
	if amount == nil then
		amount = 1
	end
	if self.OCRPData["Storage"][item] == nil then
		self.OCRPData["Storage"][item] = 1
	else
		self.OCRPData["Storage"][item] = self.OCRPData["Storage"][item] + amount
	end
	self:StorageSave()
end

function PMETA:StorageHasItem(item,amount)
	if self.OCRPData == nil then return false end
	if self.OCRPData["Storage"] == nil then return false end
	if amount == nil then amount = 1 end
	if self.OCRPData["Storage"][item] == nil then return false end
	if self.OCRPData["Storage"][item] >= amount then
		return true
	end
	return false
end

function PMETA:UnStoreItem(item,amount)
	if !self.Loaded then return end
	if self.OCRPData == nil then return end
	if item == "item_pot" then return end
	if self.OCRPData["Storage"] == nil then self.OCRPData["Storage"] = {}  end
	if amount == nil then
		amount = 1
	end
	if self.OCRPData["Storage"][item] == nil || self.OCRPData["Storage"][item] <= 1 then
		self.OCRPData["Storage"][item] = 0
	else
		self.OCRPData["Storage"][item] = self.OCRPData["Storage"][item] - amount
	end
	self:StorageSave()
end

function PMETA:StorageSave()
	if !self.Loaded then return end
	local StrindedItems = self:CompileString("storage")
	tmysql.query("UPDATE `ocrp_users` SET `storage` = '".. StrindedItems .."' WHERE `STEAM_ID` = '".. self:SteamID() .."'")
end
