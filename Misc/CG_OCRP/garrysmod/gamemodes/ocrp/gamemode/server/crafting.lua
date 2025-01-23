
function GM:ShowSpare1( ply )

	local tr = ply:GetEyeTrace()
	if tr.HitNonWorld then
		if tr.Entity:GetClass() == "prop_ragdoll" && tr.Entity.player != nil && tr.Entity:GetPos():Distance(ply:GetPos()) <= 100 then
			if ply:Team() == CLASS_CITIZEN && tr.Entity.player:IsValid() && tr.Entity.player:Team() == CLASS_CITIZEN then	
				if ply:HasSkill("skill_loot",1) then
					if tr.Entity.Lootable then
						local empty = true
						for item,amount in pairs(tr.Entity.player.OCRPData["Inventory"]) do
							if item != "WeightData" && amount > 0 then
								ply:UpdateObjectItem(tr.Entity.player,item)
								empty = false
							end	
						end
						if empty then
							ply:UpdateObject(tr.Entity.player)
						end			
						ply:ConCommand("OCRP_Loot")
						return false
					end
				end
			end
		elseif tr.Entity.OCRPData != nil and tr.Entity.OCRPData["Inventory"] != nil && tr.Entity:GetPos():Distance(ply:GetPos()) <= 100 && !tr.Entity:IsPlayer() then
			if ply:Team() == CLASS_CITIZEN then
				if ply:HasSkill("skill_loot",9) then
					if tr.Entity:GetClass() == "prop_vehicle_jeep"  then
						if !tr.Entity:GetNWBool("UnLocked") then
							ply:Hint("The car needs to be unlocked to loot")
							if tr.Entity:GetDriver():IsPlayer() then
								ply:Hint("You can't loot while somebody is driving")
							end
							return 
						end
						if tr.Entity:GetDriver():IsPlayer() then
							ply:Hint("You can't loot while somebody is driving")
							return
						end
					end
					if tr.Entity:GetClass() == "item_base" then
						if tr.Entity:GetNWInt("Class") != "item_safe01"  then
							local empty = true
							for item,amount in pairs(tr.Entity.OCRPData["Inventory"]) do
								if item != "WeightData" && amount > 0 then
									ply:UpdateObjectItem(tr.Entity,item)
									empty = false
								end	
							end
							if empty then
								ply:UpdateObject(tr.Entity)
							end			
							ply:ConCommand("OCRP_Loot")	
					
							return false
						end
					else
						local empty = true
						for item,amount in pairs(tr.Entity.OCRPData["Inventory"]) do
							if item != "WeightData" && amount > 0 then
								ply:UpdateObjectItem(tr.Entity,item)
								empty = false
							end	
						end
						if empty then
							ply:UpdateObject(tr.Entity)
						end			
						ply:ConCommand("OCRP_Loot")	
					
						return false
						
					end
				end
			end
		end
	end
	ply:ConCommand("OCRP_CraftingMenu")
end

function Craft_CraftItem(ply,recipe)
	for _,data1 in pairs(GAMEMODE.OCRP_Recipies) do
		if data1.Item == recipe then
			local bool = true
			for skill,level in pairs(data1.Skills) do
				if tonumber(level) > 0 then
					if !ply:HasSkill(tostring(skill),tonumber(level)) then
						bool = false
					end
				end
			end

			if bool then			
			
				local cando = false			
				if data1.HeatSource then
					for key,obj in pairs(ents.FindByClass("item_base")) do
						if ply:GetPos():Distance(obj:GetPos()) < 100 && obj:GetNWString("Class") == "item_furnace" then
							cando = true
							break
						end
					end
				end
				if data1.WaterSource then
					for key,obj in pairs(ents.FindByClass("item_base")) do
						if ply:GetPos():Distance(obj:GetPos()) < 100 && obj:GetNWString("Class") == "item_sink" then
							cando = true
							break
						end
					end
				end
				if !data1.WaterSource && !data1.HeatSource then
					cando = true
				end
				if !cando then
					return
				end
					local craft = true
					local itemslost = {}
					for _,data in pairs(data1.Requirements) do
						if !ply:HasItem(data.Item,data.Amount) then
							craft = false
							break
						end
					end
				if craft then
					for _,data in pairs(data1.Requirements) do
						ply:RemoveItem(data.Item,data.Amount)
					end
					local amt = 1
					if data1.Amount != nil then
						ply:GiveItem(data1.Item, data1.Amount)
					else 
						ply:GiveItem(data1.Item)
					end
					
				end
				break
			end
		end
	end	
	
end

concommand.Add("OCRP_CraftItem", function(ply, command, args) Craft_CraftItem(ply,args[1]) end)

