
function PMETA:UpdateItem(item) 
	umsg.Start("OCRP_UpdateItem", self)
		umsg.String(item)
		umsg.Long(self.OCRPData["Inventory"][item])
		umsg.Long(self.OCRPData["Inventory"].WeightData.Cur)
		umsg.Long(self.OCRPData["Inventory"].WeightData.Max)
	umsg.End()
end

function PMETA:GiveItem(item,amount,load)
	if !self:HasItem(item) then
		if GAMEMODE.OCRP_Items[item].Weapondata != nil then
			self:Give(GAMEMODE.OCRP_Items[item].Weapondata.Weapon)
			--[[if self.VisibleWeps != nil then
				for _,weapon in pairs(self.VisibleWeps) do
					if weapon.Weapon == GAMEMODE.OCRP_Items[item].Weapondata.Weapon then
						break
					end
				end
			end]]--
		--[[	if !GAMEMODE.OCRP_Items[item].Weapondata.DontDisplay then
				local weapon = ents.Create("weapon_obj")
				weapon:SetPos(self:GetPos() + Vector(0,0,40))
				weapon:SetParent(self)
				weapon:SetModel(GAMEMODE.OCRP_Items[item].Model)
				weapon.Weapon = GAMEMODE.OCRP_Items[item].Weapondata.Weapon
				weapon:Spawn()
				table.insert(self.VisibleWeps, weapon)	
				for _,ply in pairs(player.GetAll()) do 
					umsg.Start("OCRP_UpdateWeapon",ply)
						umsg.String(item)
						umsg.Long(self:EntIndex())
						umsg.Long(weapon:EntIndex())
					umsg.End()
				end
			end		
			if GAMEMODE.OCRP_Items[item].Weapondata.Setup then
				GAMEMODE.OCRP_Items[item].Weapondata.Setup(self,item)
			end]]
		end
	end
	
	self:Inv_GiveItem(item,amount)
	
	self:UpdateItem(item)
	
	if load != "LOAD" then
		GAMEMODE:SaveSQLItemNow( self, item )
	end
end

function PMETA:UseItem(item)
	if !self:Alive() then return end
	if !self:HasItem(item) then return end
	if self:InVehicle() then return end
	if GAMEMODE.OCRP_Items[item].Condition != nil then
		if GAMEMODE.OCRP_Items[item].Condition(self,item) then
			GAMEMODE.OCRP_Items[item].Function(self,item)
			self:RemoveItem(item)
		end
	else
		GAMEMODE.OCRP_Items[item].Function(self,item)
		self:RemoveItem(item)
	end
end
concommand.Add("OCRP_Useitem", function(ply, command, args) if ply:HasItem(args[1]) then ply:UseItem(args[1]) end end)

function PMETA:DropItem(item,amount)
	if !self:Alive() then return end
	if self.CantUse then self:Hint("Please wait before spawning again") return end
	local num = 0
	local multi = 1
	if self:GetLevel() <= 4 then 
		multi = 2
	end
	if self:GetLevel() <= 3 then 
		multi = 6
	end
	for _,ent in pairs(ents.FindByClass("item_base")) do 
		if ent:GetNWInt("Owner") == self:EntIndex() then
			num = num + 1
		end
	end
	if num >= math.Round(OCRPCfg["Prop_Limit"]*multi) then
		self:Hint("You have hit the prop limit")
		return
	end
	if !self:HasItem(item) then return end
	
	self:StoreItem(item,amount)	
	self:RemoveItem(item,amount)	

	
	local tr = self:GetEyeTrace()
	local DropedEnt = ents.Create("item_base")
	DropedEnt:SetNWString("Class", item)
	DropedEnt:SetNWInt("Owner",self:EntIndex())
	DropedEnt.Amount = amount
	if GAMEMODE.OCRP_Items[item].Spawnable then
		DropedEnt:SetPos(self:GetPos())
	else
		DropedEnt:SetPos(self:EyePos() + (self:GetAimVector() * 30))
	end
	DropedEnt:SetAngles(Angle(0,self:EyeAngles().y ,0))
	DropedEnt:Spawn()
	
	if DropedEnt:GetPhysicsObject():IsValid() then
		DropedEnt:GetPhysicsObject():ApplyForceCenter(self:GetAimVector() * 120)
	end
	
	self:UpdateItem(item)
	self.CantUse = true
	timer.Simple(1,function() if self:IsValid() then self.CantUse = false end end)
end
concommand.Add("OCRP_Dropitem", function(ply, command, args)
	local amt
	if args[2] == nil then
		amt = 1 
	else
		amt = args[2]
	end
	if tonumber(amt) < 0 then return false end
 	if ply.OCRPData["Inventory"][args[1]] then
		if math.abs(tonumber(amt)) > tonumber(ply.OCRPData["Inventory"][args[1]]) then
			return false
		end
	end
	if ply:HasItem(args[1]) then
		ply:DropItem(args[1],args[2])
	end
end)

function PMETA:RemoveItem(item,amount)
	
	self:Inv_RemoveItem(item,amount)

	for class,data in pairs(GAMEMODE.OCRP_Items) do 
		if item == class then
			if data.Weapondata != nil then
				if !self:HasItem(item) then
					if data.Weapondata.Weapon == "weapon_physgun" then 
						if self:GetLevel() > 4 then
							self:StripWeapon(data.Weapondata.Weapon)
						end
					else
						self:StripWeapon(data.Weapondata.Weapon)
					end
					--[[if self.VisibleWeps != nil then
						for _,weapon in pairs(self.VisibleWeps) do
							if weapon.Weapon == data.Weapondata.Weapon then
								table.remove(self.VisibleWeps,_)
								weapon:Remove()
								break
							end
						end
					end	]]--
				
				end
			end
		end
	end
	
	self:UpdateItem(item)
	GAMEMODE:SaveSQLItemNow( self, item )
end

function PMETA:HasItem(item,amount)
	if self.OCRPData["Inventory"] == nil then return false end
	if amount == nil then amount = 1 end
	if self.OCRPData["Inventory"][item] == nil then return false end
	if self.OCRPData["Inventory"][item] >= amount then
		return true
	end
	return false
end

function PMETA:HasRoom(item,amount)
	if self.OCRPData["Inventory"] == nil then return false end
	if amount == nil then amount = 1 end
	if (self.OCRPData["Inventory"].WeightData.Cur + (GAMEMODE.OCRP_Items[item].Weight * amount)) <= self.OCRPData["Inventory"].WeightData.Max then
		return true
	end
	return false
end

function PMETA:UpdateAmmoCount()
	self:StripAmmo()
	for item,amount in pairs(self.OCRPData["Inventory"]) do
		if item != "WeightData" && amount > 0 then
			if GAMEMODE.OCRP_Items[item].AmmoType != nil then
				self:GiveAmmo( amount, GAMEMODE.OCRP_Items[item].AmmoType,true )
			end
		end
	end
end


