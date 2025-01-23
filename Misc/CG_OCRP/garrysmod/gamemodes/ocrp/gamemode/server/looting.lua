
function PMETA:LootItem(item,Objectid)
	local carryon = false
	local Object = ents.GetByIndex(Objectid)
	for _, ent in pairs(ents.FindInSphere(self:GetPos(), 100)) do
		if ent:EntIndex() == Objectid then
			carryon = true
		end
	end
	if carryon == false then return false end
	if Object == self then return end
	if Object:IsPlayer() && !self:HasSkill("skill_loot") then return end
	if Object:GetNWInt("Owner") != self:EntIndex() && !self:HasSkill("skill_loot",1) then return end
	if Object:GetClass() == "prop_vehicle_jeep" then if Object:GetDriver():IsPlayer() then return end end
	local chance = math.random(1,2)
	if self:HasRoom(item,1) && Object:HasItem(item) then
		if chance == 1 then
			if self:HasSkill("skill_loot",GAMEMODE.OCRP_Items[item].LootData.Level) then
				local itemobj = ents.Create("item_base")
				itemobj:SetNWString("Class",item)
				itemobj:SetPos(Object:GetPos() + Vector(0,0,20))
				if Object:IsPlayer()  then
					if !Object:Alive() && Object:Team() == CLASS_CITIZEN && Object:GetRagdoll().Lootable  then
						Object:RemoveItem(item)
						Object:Hint(""..GAMEMODE.OCRP_Items[item].Name.." has been stolen from your inventory")
						itemobj:SetPos(Object:GetRagdoll():GetPos() + Vector(0,0,20))
					else
						return
					end
				elseif self:HasSkill("skill_loot",9) then
					Object:Inv_RemoveItem(item)
					player.GetByID(Object:GetNWInt("Owner")):UnStoreItem(item,1)	
					itemobj:SetPos(Object:GetPos() + Vector(0,0,20))
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
				itemobj:Spawn() 
				self:Hint("Looting Successful")
				itemobj:Activate()
				itemobj:GetPhysicsObject():Wake()
			end
		else
			self:Hint("looting unsuccessful")
		end
		self:StopSound("physics/body/body_medium_scrape_rough_loop1.wav")
	end
end
concommand.Add("OCRP_LootItem", function(ply, command, args) ply:LootItem(tostring(args[1]),tonumber(args[2]))  end)

function PMETA:BeginLooting(item,Objectid)
	self:EmitSound("physics/body/body_medium_scrape_rough_loop1.wav",40,100)
end
concommand.Add("OCRP_BeginLooting", function(ply, command, args) ply:BeginLooting(tostring(args[1]),tonumber(args[2]))  end)
