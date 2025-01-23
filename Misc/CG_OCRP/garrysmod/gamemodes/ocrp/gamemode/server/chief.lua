function Police_AddMoney(amt)
	local money = GAMEMODE.PoliceMoney
	if amt == nil then
		return
	end
	if money + amt < 0 then
		GAMEMODE.PoliceMoney = 0
	else
		GAMEMODE.PoliceMoney = money + amt
	end
	Police_Update()
end

function Police_HasMoney(amt)
	if GAMEMODE.PoliceMoney >= amt then
		return true
	end
	return false
end

function Police_Update()
	if team.NumPlayers(CLASS_CHIEF) <= 0 then return end
	for _,ply in pairs(team.GetPlayers(CLASS_CHIEF)) do
		if ply:IsValid() then
			umsg.Start("OCRP_PoliceUpdate", ply)
				umsg.Long((GAMEMODE.PoliceMoney))
				umsg.Long(GAMEMODE.Police_Maxes["item_ammo_cop"])
				umsg.Long(GAMEMODE.Police_Maxes["item_ammo_riot"])
				umsg.Long(GAMEMODE.Police_Maxes["item_ammo_ump"])
			umsg.End()		
		end
	end
end

function Police_TakeMoney(amt)
	local money = GAMEMODE.PoliceMoney
	if amt == nil then
		return
	end
	if money - amt < 0 then
		GAMEMODE.PoliceMoney = 0
	else
		GAMEMODE.PoliceMoney = money - amt
	end
	Police_Update()
end

function Police_CreateObject(ply,obj)
	if ply:Team() != CLASS_CHIEF then return end
	if ply:InVehicle() then return end
	if Police_HasMoney(GAMEMODE.Chief_Items[obj].Price)  then
		local object = GAMEMODE.Chief_Items[obj].SpawnFunction(ply)
		if GAMEMODE.Mayor_Items[obj].Price > 0 then
			Police_TakeMoney(  GAMEMODE.Mayor_Items[obj].Price )
		end
		if GAMEMODE.Chief_Items[obj].Time > 0 then
			timer.Simple(GAMEMODE.Chief_Items[obj].Time,function() if object:IsValid() then object:Remove() end end)
		end
	else
		ply:Hint("The force can't afford that!")
	end
end
concommand.Add("OCRP_Chief_CreateObj",function(ply,cmd,args) Police_CreateObject(ply,tostring(args[1])) end)
function Police_Update_Max(item,amount)
	if ply:Team() != CLASS_CHIEF then return end
	GAMEMODE.Police_Maxes[item] = amount
end
concommand.Add("OCRP_PoliceMax_Update", function(ply,cmd,args) Police_Update_Max(ply,args[1],math.Round(args[2])) end)

function Police_SupplyLocker(ply,item,amt)
	if ply:Team() != CLASS_CHIEF then return false end
	for _,data in pairs(GAMEMODE.Locker_Items) do
		if data.Item == item then
			if Police_HasMoney(data.Price*amt) then
				for _,ent in pairs(ents.FindByClass("gov_resupply")) do
					if ent:IsValid() then
						ent:Inv_GiveItem(item,amt)
						break
					end
				end
				for _,data in pairs(GAMEMODE.Locker_Items) do
					if data.Item == item then
						Police_TakeMoney(data.Price*amt)
					end
				end
				ply:Hint("The force purchased some "..GAMEMODE.OCRP_Items[item].Name)
			else
				ply:Hint("The force can't afford that!")
			end
			break
		end
	end
end
concommand.Add("OCRP_Chief_Supply_Locker", function(ply, command, args)	Police_SupplyLocker(ply,tostring(args[1]),math.Round(args[2])) end)

function PMETA:SwatAsk()
	if self:Team() != CLASS_POLICE then return end
	umsg.Start("OCRP_AskSwat", self)
	umsg.End()		
end
concommand.Add("OCRP_Swat_Ask",function(ply1,cmd,args)
									for _,ply in pairs(team.GetPlayers(CLASS_POLICE)) do
										if ply:IsValid() && ply:Nick() == tostring(args[1]) && Police_HasMoney(50) then
											ply:SwatAsk()		
											break
										end
									end
								end)

function PMETA:SwatReply(bool,weapon)
	if self:Team() != CLASS_POLICE then return end
	if !tobool(bool) then for _,ply in pairs(team.GetPlayers(CLASS_CHIEF)) do ply:Hint("Swat request denied") end return end
	if !Police_HasMoney(50) then return end
	if weapon == 0 then
		self:SwatUpgrade("swat_shotgun_ocrp")
		self:GiveItem("item_ammo_riot",8)
	else
		self:SwatUpgrade("swat_ump45_ocrp")
		self:GiveItem("item_ammo_ump",25)
	end
end
concommand.Add("OCRP_Swat_Reply",function(ply,cmd,args) ply:SwatReply(args[1],math.Round(args[2])) end)

function PMETA:SwatUpgrade(weapon)
	Police_TakeMoney(50)
	self.DueToBeSWAT = true
	OCRP_Job_Quit(self)
	OCRP_Job_Join(self,CLASS_SWAT)
	self:Give(weapon)
	self:Hint("You have upgraded to swat")
end

concommand.Add("OCRP_Hire_Police_Chief",function(ply,cmd,args) 
	for _,v in pairs(player.GetAll()) do 
		if v:Nick() == tostring(args[1]) && v:Team() == CLASS_POLICE && Mayor_HasMoney(250) then
			v.DueToBeChief = true
			Mayor_TakeMoney(250)
			OCRP_Job_Quit(v)
			OCRP_Job_Join(v,CLASS_CHIEF)
			v:Hint("You have been appointed to police chief")
		end 
	end
end)

